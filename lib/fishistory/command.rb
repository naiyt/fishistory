module Fishistory
  # TODO: Add more cool scopes
  # TODO: Spec this
  # TODO: Add a way to "recommend" aliases

  class Command < ActiveRecord::Base
    scope :success,                lambda { where(rc: 0) }
    scope :not_success,            lambda { where("rc IS NOT 0") }
    scope :by_frequency,           lambda { select("*, count(command) as freq")
                                            .order("freq desc")
                                            .group(:command) }

    scope :by_full_cmd_frequency,  lambda { select("*, count(full_command) as freq")
                                            .order("freq desc")
                                            .group(:full_command) }

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

    # TODO: make sure this all gets sanitized properly
    def create_cmd!(cmd_hash)
      command = Command.new
      split_command = cmd_hash["cmd"].to_s.split("\s")
      command.full_command = cmd_hash["cmd"]
      command.command = split_command[0]
      command.args = split_command.length == 1 ? nil : split_command[1..-1].join(" ")
      command.start_timestamp = to_time(cmd_hash["start"])
      command.end_timestamp = to_time(cmd_hash["end"])
      command.rc = cmd_hash["rc"]
      command.host = cmd_hash["host"]
      command.save
    end

    def to_time(timestamp)
      Time.at(timestamp.to_i)
    end

    # TODO: is it the best choice to use pry here?
    def console
      Command.connection
      binding.pry
    end
  end
end

