require "rspec/core/rake_task"
require "active_record"
require "yaml"
require "pry"
require "fishistory"

task :default => :spec
RSpec::Core::RakeTask.new

task :install do
  puts "Setting up the fishistory config and function"
  config = Fishistory.config
  installer = Fishistory::Installer.new(config)
  installer.run

  puts "Setting up the fishistory sqlite database"
  details = YAML.load_file('db/database.yml')
  ActiveRecord::Base.establish_connection(details)

  ActiveRecord::Migration.class_eval do
    create_table :commands do |t|
      t.string :command
      t.string :args
      t.string :start_timestamp
      t.string :end_timestamp
      t.integer :rc
      t.string :host
    end
  end
end

