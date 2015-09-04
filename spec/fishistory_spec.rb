require "spec_helper"

describe Fishistory do
  describe "#configure" do
    it "defaults fish_root_path to ~/.config/fish" do
      expect(Fishistory.config.fish_root_path).to eq('~/.config/fish')
    end

    it "allows you to set fish_root_path" do
      Fishistory.configure { |c| c.fish_root_path = '~/fish/are/tasty' }

      expect(Fishistory.config.fish_root_path).to eq('~/fish/are/tasty')
    end
  end
end

