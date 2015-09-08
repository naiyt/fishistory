require "fileutils"

# TODO: add an uninstaller
# TODO: print info

module Fishistory
  class Installer
    def initialize(config)
      @config = config
    end

    def run
      raise FishNotInstalledError unless fish_installed?
      create_dir!(fishistory_dir)
      copy_fishistory_func!(fishistory_func_file, func_dir)
      add_fishistory_call_to_config!(fish_config_file)
    end


    private


    #
    # Methods with FS side effects
    #

    def create_dir!(dir, mode = 0755)
      FileUtils.mkdir(dir, mode: mode) unless File.directory?(dir)
    end

    def copy_fishistory_func!(src, dest)
      FileUtils.cp(src, dest)
    end

    def add_fishistory_call_to_config!(fish_config_file)
      unless fish_config_file.grep(/\Afishistory\Z/).any?
        fish_config_file.write("fishistory\n")
      end
      fish_config_file.close
    end


    #
    # File location helpers
    #

    def fishistory_dir
      File.join(File.expand_path(@config.fish_root_path), 'fishistory')
    end

    def func_dir
      File.join(File.expand_path(@config.fish_root_path), 'functions')
    end

    def fishistory_func_file
      File.join(FileUtils.pwd, 'lib', 'files', 'fishistory.fish')
    end

    def fish_config_file
      f = File.join(File.expand_path(@config.fish_root_path), 'config.fish')
      File.open(f, 'r+')
    end


    #
    # Other helper methods
    #

    def fish_installed?
      # TODO: verify they have 2.2.0 (required for post/pre-exec events)
      which 'fish'
    end

    # http://stackoverflow.com/a/5471032/1026980
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        }
      end
      return nil
    end
  end
end

