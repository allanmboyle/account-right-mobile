describe AccountRight::API::Request do

  let(:resource_path) { "some/resource/path" }
  let(:access_token) { "some token" }
  let(:security_tokens) { { access_token: access_token } }
  let(:request) { AccountRight::API::Request.new(resource_path, security_tokens) }

  describe "#uri" do

    it "should return the resource path requested appended to the configured base API URI" do
      request.uri.should eql("#{AccountRightMobile::Application.config.api["uri"]}/#{resource_path}")
    end

  end

  describe "#headers" do

    it "should contain an authorization header whose value is the access security token prefixed with 'Bearer'" do
      request.headers.should include("Authorization" => "Bearer #{access_token}")
    end

    it "should contain an API key header whose value is the configured API key" do
      request.headers.should include("x-myobapi-key" => AccountRightMobile::Application.config.api["key"])
    end

    it "should contain an encoding header whose value is requests a gzip response" do
      request.headers.should include("Accept-Encoding" => "gzip,deflate")
    end

    describe "when a customer file security token is provided" do

      let(:cf_token) { "some_cf_token" }
      let(:security_tokens) { { access_token: access_token, cf_token: cf_token } }

      it "should contain a cftoken header whose value is the customer file security token" do
        request.headers.should include("x-myobapi-cftoken" => cf_token)
      end

    end

  end

  describe "#security_tokens" do

    it "should return the provided tokens" do
      request.security_tokens.should eql(security_tokens)
    end

  end

  describe "#to_s" do

    it "should contain the uri of the request" do
      request.to_s.should include(request.uri)
    end

    it "should contain the headers of the request" do
      request.to_s.should include(request.headers.to_s)
    end

  end

end
