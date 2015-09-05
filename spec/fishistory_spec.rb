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

  describe ".install" do

    let(:config)                        { Fishistory::Config.new }
    let(:installer)                     { Fishistory::Installer.new(config) }
    let(:funcs_with_filesystem_effects) { [:create_dir!, :copy_fishistory_func!, :add_fishistory_call_to_config! ]}

    context "fish is not installed" do
      it "does not install anything" do
        allow(installer).to receive(:fish_installed?).and_return(false)
        expect { installer.run }.to raise_error(Fishistory::FishNotInstalledError)
      end
    end

    context "fish is installed" do
      let(:dir) { File.join(File.expand_path(config.fish_root_path), 'fishistory') }

      before do
        allow(installer).to receive(:fish_installed?).and_return(true)
        funcs_with_filesystem_effects.each { |se| allow(installer).to receive(se) }
      end

      it "creates the fishistory directory in your fish_root_path" do
        expect(installer).to receive(:create_dir!).with(dir)
        installer.run
      end

      it "makes the fishistory function file" do
        fishistory_file = File.join(FileUtils.pwd, 'lib', 'files', 'fishistory.fish')
        fishistory_dir = File.join(File.expand_path(config.fish_root_path), 'functions')
        expect(installer).to receive(:copy_fishistory_func!).with(fishistory_file, fishistory_dir)
        installer.run
      end

      describe "adding fishistory call in config.fish" do
        let(:config_file) { double("file") }

        before do
          expect(installer).to receive(:add_fishistory_call_to_config!).and_call_original
          allow(installer).to receive(:fish_config_file).and_return(config_file)
        end

        context "the line already exists" do
          it "does nothing" do
            allow(config_file).to receive(:grep).and_return(["fishistory"])
            allow(config_file).to receive(:close)
            installer.run
          end
        end

        context "the line does not exist" do
          it "adds the line to the config" do
            allow(config_file).to receive(:grep).and_return([])
            allow(config_file).to receive(:write)
            allow(config_file).to receive(:close)
            installer.run
          end
        end
      end
    end
  end
end

