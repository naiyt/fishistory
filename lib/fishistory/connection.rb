module Fishistory
  class Connection
    def self.db_connect
      ActiveRecord::Base.establish_connection(YAML.load_file('db/database.yml'))
    end
  end
end
j
