module Fishistory
  class Command < ActiveRecord::Base
    scope :success,       lambda { where(rc: 0) }
    scope :not_success,   lambda { where("rc IS NOT 0") }
    scope :by_frequency,  lambda { select("command, count(command) as freq").order("freq desc").group("command") }
    scope :by_hostname,   lambda { |host| where(host: host) }

    def self.by_running_time
      Command.all.sort_by(&:running_time)
    end

    def self.most_frequent(count=20)
      by_frequency.limit(count)
    end

    def running_time
      end_timestamp - start_timestamp
    end
  end

  class CommandsController
    def initialize(archive_old=true)
      Connection.db_connect
      @archive_old = archive_old
      @parser = Parser.new
    end

    def parse_and_save!
      commands = @parser.parse!(archive_old=@archive_old)
      commands.each { |cmd_hash| create_cmd!(cmd_hash)  }
    end

    def create_cmd!(cmd_hash)
      command = Command.new
      full_cmd = cmd_hash["cmd"].to_s.split("\s")
      command.command = full_cmd[0]
      command.args = full_cmd.length == 1 ? nil : full_cmd[1..-1].join(" ")
      command.start_timestamp = cmd_hash["start"]
      command.end_timestamp = cmd_hash["end"]
      command.rc = cmd_hash["rc"]
      command.host = cmd_hash["host"]
      command.save!
    end

    def console
      Command.connection
      binding.pry
    end
  end
end

