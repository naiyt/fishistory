module Fishistory
  class Config
    attr_accessor :fish_root_path

    def initialize
      @fish_root_path = "~/.config/fish"
    end 
  end
end

