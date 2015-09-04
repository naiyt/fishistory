require "spec_helper"

describe Fishistory do
  describe "#configure" do
    let(:subject) { Fishistory.config}

    it "defaults fish_root_path to ~/.config/fish" do
      expect(subject.fish_root_path).to eq('~/.config/fish')
    end

    it "allows you to set fish_root_path" do
      Fishistory.configure { |c| c.fish_root_path = '~/fish/are/tasty' }
      expect(subject.fish_root_path).to eq('~/fish/are/tasty')
    end

    it "sets default database settings" do
      expect(subject.adapter).to  eq('sqlite3')
      expect(subject.database).to eq('fishistory')
      expect(subject.username).to eq('root')
      expect(subject.password).to eq('password')
    end

    it "allows you to configure database settings" do
      Fishistory.configure do |config|
        config.adapter  = 'mysql2'
        config.database = 'shrimp'
        config.username = 'shark'
        config.password = 'marlin'
      end

      expect(subject.adapter).to  eq('mysql2')
      expect(subject.database).to eq('shrimp')
      expect(subject.username).to eq('shark')
      expect(subject.password).to eq('marlin')
    end
  end
end

