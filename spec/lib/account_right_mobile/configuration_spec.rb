describe AccountRightMobile::Configuration do

  let(:default_settings) do
    { "key1" => "value1",
      "key2" => { "nestedkey1" => "nestedvalue1",
                  "nestedkey2" => "nestedvalue2.1" } }
  end

  let(:environment_settings) do
    { "key2" => { "nestedkey2" => "nestedvalue2.2",
                  "nestedkey3" => "nestedvalue3" },
      "key3" => "value3" }
  end

  let(:environment) { "test" }
  let(:default_file_path) { "#{Rails.root}/config/defaults.yml" }
  let(:configuration_gem_installed) { defined? AccountRightMobileConfiguration::Configuration }

  before(:each) do
    Rails.stub!(:env).and_return(environment)
    YAML.stub!(:load_file).with(default_file_path).and_return(default_settings)
  end

  describe "#load" do

    describe "when the configuration gem has been installed" do

      before(:each) do
        module AccountRightMobileConfiguration
          class Configuration
          end
        end unless configuration_gem_installed

        AccountRightMobileConfiguration::Configuration.stub!(:load_for).and_return(environment_settings)
      end

      after(:each) do
        Object.send(:remove_const, :AccountRightMobileConfiguration) unless configuration_gem_installed
      end

      describe "and the configuration gem returns settings" do

        it "should return a hash that contains default settings" do
          AccountRightMobile::Configuration.load.should include("key1" => "value1")
        end

        it "should return a hash that contains the configuration gems settings" do
          AccountRightMobile::Configuration.load.should include("key3" => "value3")
        end

        it "should override the default settings with configuration gems settings" do
          AccountRightMobile::Configuration.load.should include("key2" => { "nestedkey1" => "nestedvalue1",
                                                                            "nestedkey2" => "nestedvalue2.2",
                                                                            "nestedkey3" => "nestedvalue3" })
        end

      end

      describe "when the configuration gem returns empty settings" do

        before(:each) { AccountRightMobileConfiguration::Configuration.stub!(:load_for).and_return({}) }

        it "should return the default settings" do
          AccountRightMobile::Configuration.load.should eql(default_settings)
        end

      end

      describe "when the Rails environment is development" do

        let(:environment) { "development" }

        it "should load the development environments settings from the configuration gem" do
          AccountRightMobileConfiguration::Configuration.should_receive(:load_for).with(environment)

          AccountRightMobile::Configuration.load
        end

      end

      describe "when the Rails environment is test" do

        let(:environment) { "test" }

        it "should load the test environments settings from the configuration gem" do
          AccountRightMobileConfiguration::Configuration.should_receive(:load_for).with(environment)

          AccountRightMobile::Configuration.load
        end

      end

      describe "when the Rails environment is production" do

        let(:environment) { "production" }

        it "should load the production environments settings from the configuration gem" do
          AccountRightMobileConfiguration::Configuration.should_receive(:load_for).with(environment)

          AccountRightMobile::Configuration.load
        end

      end

    end

    describe "when the configuration gem has not been installed" do

      before(:each) do
        @initial_configuration_module = configuration_gem_installed ? ::AccountRightMobileConfiguration : nil
        Object.send(:remove_const, :AccountRightMobileConfiguration) if configuration_gem_installed
      end

      after(:each) do
        ::AccountRightMobileConfiguration = @initial_configuration_module if configuration_gem_installed
      end

      it "should return the default settings" do
        AccountRightMobile::Configuration.load.should eql(default_settings)
      end

    end

  end

end
