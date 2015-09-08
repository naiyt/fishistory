require 'fishistory/config'
require 'fishistory/exceptions'
require 'fishistory/install'
require 'fishistory/parser'
require 'fishistory/command'
require 'fishistory/connection'

module Fishistory
  def self.configure
    yield config
  end

  def self.config
    @config ||= Config.new
  end

  def self.reset
    @config = Config.new
  end
end

