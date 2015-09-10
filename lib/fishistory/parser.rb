require "fileutils"
require "yaml"

# TODO: add specs

module Fishistory
  class Parser
    attr_accessor :commands

    # TODO: this should get initialized by a config object
    def initialize(history_path="~/.config/fish/fishistory")
      @history_path = File.expand_path(history_path)
      @parsed_path = File.join(@history_path, 'parsed')
    end

    def parse!(archive_old=true)
      ensure_parsed_dir!
      parsed = parse_files(files)
      files.each { |f| mv_to_parsed(f) } if archive_old
      parsed
    end

    private

    def ensure_parsed_dir!
      FileUtils.mkdir(@parsed_path) unless File.directory?(@parsed_path)
    end

    def parse_files(to_parse)
      to_parse.map do |f|
        begin
          YAML::load_file(f)
        rescue Psych::SyntaxError
        end
      end.flatten
    end

    def files
      @files ||= Dir["#{@history_path}/*.txt"]
    end

    # TODO: this should probably tar them up or something
    def mv_to_parsed(file_path)
      FileUtils.mv(file_path, @parsed_path)
    end
  end
end

