describe AccountRight::API do

  let(:logger) { double("Logger").as_null_object }

  before(:each) { Rails.stub!(:logger).and_return(logger) }

  describe ".invoke" do

    let(:uri) { "some uri" }
    let(:access_token) { "some token" }
    let(:response_code) { 200 }
    let(:response_body) { "some response body" }
    let(:response) { double("HTTPResponse", :body => response_body, :code => response_code) }

    before(:each) { HTTParty.stub!(:get).and_return(response) }

    it "should log the requested URI at info level" do
      logger.should_receive(:info).with(/#{uri}/)

      AccountRight::API.invoke(uri, access_token)
    end

    it "should log the request access token header at info level" do
      logger.should_receive(:info).with(/Authorization.*#{access_token}/)

      AccountRight::API.invoke(uri, access_token)
    end

    it "should log the request api-key header at info level" do
      logger.should_receive(:info).with(/x-myobapi-key.*#{AccountRightMobile::Application.config.api["key"]}/)

      AccountRight::API.invoke(uri, access_token)
    end

    describe "when a cftoken is provided" do

      let(:cf_token) { "some_cf_token" }

      it "should log the request x-myobapi-cftoken header at info level" do
        logger.should_receive(:info).with(/x-myobapi-cftoken.*#{cf_token}/)

        AccountRight::API.invoke(uri, access_token, cf_token)
      end

    end

    it "should log the response status at info level" do
      logger.should_receive(:info).with(/#{response_code}/)

      AccountRight::API.invoke(uri, access_token)
    end

    it "should log the response body at info level" do
      logger.should_receive(:info).with(/#{response_body}/)

      AccountRight::API.invoke(uri, access_token)
    end

    describe "and a 200 response is received" do

      let(:response_code) { 200 }

      it "should execute successfully" do
        AccountRight::API.invoke(uri, access_token)
      end

    end

    describe "and a 300-range response is received" do

      let(:response_code) { 300 }

      it "should raise an error with the response body" do
        lambda { AccountRight::API.invoke(uri, access_token) }.should raise_error(AccountRight::ApiError, response_body)
      end

    end

    describe "and a 400-range response is received" do

      let(:response_code) { 400 }

      it "should raise an error with the response body" do
        lambda { AccountRight::API.invoke(uri, access_token) }.should raise_error(AccountRight::ApiError, response_body)
      end

    end

    describe "and a 500-range response is received" do

      let(:response_code) { 500 }

      it "should raise an error with the response body" do
        lambda { AccountRight::API.invoke(uri, access_token) }.should raise_error(AccountRight::ApiError, response_body)
      end

    end

  end

end
