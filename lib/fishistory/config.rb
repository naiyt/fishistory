module Fishistory
  class Config
    attr_accessor :fish_root_path, :adapter, :database, :username, :password

    def initialize
      @fish_root_path = "~/.config/fish"
      @adapter = 'sqlite3'
      @database = 'fishistory'
      @username = 'root'
      @password = 'password'
    end 
  end
end

