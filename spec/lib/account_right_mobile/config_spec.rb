describe AccountRightMobile::Config do

  let(:default_settings) do
    { "key1" => "value1",
      "key2" => { "nestedkey1" => "nestedvalue1",
                  "nestedkey2" => "nestedvalue2.1" } }
  end

  let(:test_settings) do
    { "key2" => { "nestedkey2" => "nestedvalue2.2",
                  "nestedkey3" => "nestedvalue3" },
      "key3" => "value3" }
  end

  before(:each) do
    YAML.stub!(:load_file).with("#{Rails.root}/lib/account_right_mobile/config/public/defaults.yml")
                          .and_return(default_settings)
    YAML.stub!(:load_file).with("#{Rails.root}/lib/account_right_mobile/config/public/test.yml")
                          .and_return(test_settings)
  end

  describe "#load" do

    describe "when the Rails environment is development" do

      before(:each) { Rails.stub!(:env).and_return("development") }

      it "should load the development yaml file from a publicly accessible directory" do
        YAML.should_receive(:load_file).with("#{Rails.root}/lib/account_right_mobile/config/public/development.yml")

        AccountRightMobile::Config.load
      end

    end

    describe "when the Rails environment is test" do

      before(:each) { Rails.stub!(:env).and_return("test") }

      it "should load the test yaml file from a publicly accessible directory" do
        YAML.should_receive(:load_file).with("#{Rails.root}/lib/account_right_mobile/config/public/test.yml")

        AccountRightMobile::Config.load
      end

    end

    describe "when the Rails environment is production" do

      before(:each) { Rails.stub!(:env).and_return("production") }

      it "should load the production yaml file from a privately accessible directory" do
        YAML.should_receive(:load_file).with("#{Rails.root}/lib/account_right_mobile/config/private/production.yml")

        AccountRightMobile::Config.load
      end

    end

    describe "when the environment files is empty" do

      before(:each) do
        YAML.stub!(:load_file).with("#{Rails.root}/lib/account_right_mobile/config/public/test.yml")
                              .and_return(false)
      end

      it "should return the default settings" do
        AccountRightMobile::Config.load.should include(default_settings)
      end

    end

    describe "when the default file is empty" do

      before(:each) do
        YAML.stub!(:load_file).with("#{Rails.root}/lib/account_right_mobile/config/public/defaults.yml")
                              .and_return(false)
      end

      it "should return the environment specific settings" do
        AccountRightMobile::Config.load.should include(test_settings)
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
