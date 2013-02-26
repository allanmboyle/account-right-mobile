describe AccountRightMobile::Config do

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
  let(:default_file_path) { "#{Rails.root}/lib/account_right_mobile/config/public/defaults.yml" }
  let(:environment_file_path) { "#{Rails.root}/lib/account_right_mobile/config/public/#{environment}.yml" }

  before(:each) do
    Rails.stub!(:env).and_return(environment)

    File.stub!(:exists?).with(default_file_path).and_return(true)
    File.stub!(:exists?).with(environment_file_path).and_return(true)
    YAML.stub!(:load_file).with(default_file_path).and_return(default_settings)
    YAML.stub!(:load_file).with(environment_file_path).and_return(environment_settings)
  end

  describe "#load" do

    describe "when the Rails environment is development" do

      let(:environment) { "development" }

      it "should load the development yaml file from a publicly accessible directory" do
        YAML.should_receive(:load_file).with(environment_file_path)

        AccountRightMobile::Config.load
      end

    end

    describe "when the Rails environment is test" do

      let(:environment) { "test" }

      it "should load the test yaml file from a publicly accessible directory" do
        YAML.should_receive(:load_file).with(environment_file_path)

        AccountRightMobile::Config.load
      end

    end

    describe "when the Rails environment is production" do

      let(:environment) { "production" }
      let(:environment_file_path) { "#{Rails.root}/lib/account_right_mobile/config/private/production.yml" }

      it "should load the production yaml file from a privately accessible directory" do
        YAML.should_receive(:load_file).with(environment_file_path)

        AccountRightMobile::Config.load
      end

    end

    describe "when the environment file is empty" do

      before(:each) { YAML.stub!(:load_file).with(environment_file_path).and_return(false) }

      it "should return the default settings" do
        AccountRightMobile::Config.load.should eql(default_settings)
      end

    end

    describe "when the environment file does not exist" do

      before(:each) { File.stub!(:exists?).with(environment_file_path).and_return(false) }

      it "should return the default settings" do
        AccountRightMobile::Config.load.should eql(default_settings)
      end

    end

    describe "when the default file is empty" do

      before(:each) do
        YAML.stub!(:load_file).with(default_file_path).and_return(false)
      end

      it "should return the environment specific settings" do
        AccountRightMobile::Config.load.should include(environment_settings)
      end

    end

    describe "when the default file does not exist" do

      before(:each) { File.stub!(:exists?).with(default_file_path).and_return(false) }

      it "should return the environment settings" do
        AccountRightMobile::Config.load.should eql(environment_settings)
      end

    end

    it "should return a hash that contains default settings" do
      AccountRightMobile::Config.load.should include("key1" => "value1")
    end

    it "should return a hash that contains environment specific settings" do
      AccountRightMobile::Config.load.should include("key3" => "value3")
    end

    it "should override the default settings with environment specific settings" do
      AccountRightMobile::Config.load.should include("key2" => { "nestedkey1" => "nestedvalue1",
                                                                 "nestedkey2" => "nestedvalue2.2",
                                                                 "nestedkey3" => "nestedvalue3" })
    end

  end

end
