require "rspec/core/rake_task"
require "yaml"
require "pry"
require "fishistory"

task :default => :spec
RSpec::Core::RakeTask.new

# TODO: Add task descriptions
# TODO: Example .rb file that you can run that essentially
#       just imports Fishistory and does a query

namespace :fishistory do

  # TODO: Extract most of this to a helper module
  # TODO: Better print statements about the status
  task :install do
    config = Fishistory.config
    installer = Fishistory::Installer.new(config)
    installer.run


    Fishistory::Connection.db_connect

    # TODO: Figure out how to get this working w/schema migrations (a-la Rails)
    unless ActiveRecord::Base.connection.table_exists?(:commands)
      ActiveRecord::Migration.class_eval do
        create_table :commands do |t|
          t.string :command
          t.string :args
          t.string :full_command
          t.datetime :start_timestamp
          t.datetime :end_timestamp
          t.integer :rc
          t.string :host
        end
      end
    end
  end

  # TODO: Command line parameter to prevent moving old history files
  task :save do
    controller = Fishistory::CommandsController.new
    controller.parse_and_save!
  end

  task :console do
    controller = Fishistory::CommandsController.new
    controller.console
  end
end

