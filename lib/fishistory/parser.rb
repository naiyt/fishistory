require "fileutils"
require "yaml"

module Fishistory
  class Parser
    attr_accessor :commands

    def initialize(history_path="~/.config/fish/fishistory")
      @history_path = File.expand_path(history_path)
      @parsed_path = File.join(@history_path, 'parsed')
    end

    def parse!(archive_old=true)
      puts archive_old
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
      to_parse.map { |f| YAML::load_file(f) }.flatten
    end

    def files
      @files ||= Dir["#{@history_path}/*.txt"]
    end

    def mv_to_parsed(file_path)
      FileUtils.mv(file_path, @parsed_path)
    end
  end
end

