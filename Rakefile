require "rspec/core/rake_task"
require "active_record"
require "yaml"
require "pry"
require "fishistory"

task :default => :spec
RSpec::Core::RakeTask.new

namespace :fishistory do
   task :install do
    puts "Setting up the fishistory config and function"
    config = Fishistory.config
    installer = Fishistory::Installer.new(config)
    installer.run

    puts "Setting up the fishistory sqlite database"

    Fishistory::Connection.db_connect

    unless ActiveRecord::Base.connection.table_exists?(:commands)
      ActiveRecord::Migration.class_eval do
        create_table :commands do |t|
          t.string :command
          t.string :args
          t.integer :start_timestamp
          t.integer :end_timestamp
          t.integer :rc
          t.string :host
        end
      end
    end
  end

  task :save do
    controller = Fishistory::CommandsController.new
    controller.parse_and_save!
  end

  task :console do
    controller = Fishistory::CommandsController.new
    controller.console
  end
end

