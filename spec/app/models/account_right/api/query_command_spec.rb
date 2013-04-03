describe AccountRight::API::QueryCommand do

  let(:resource_path) { "some/resource/path" }
  let(:security_tokens) { { token_key: "token_value" } }

  describe "constructor" do

    it "should compose a request containing the provided resource path and security tokens" do
      AccountRight::API::Request.should_receive(:new).with(resource_path, security_tokens)

      AccountRight::API::QueryCommand.new(resource_path, security_tokens)
    end

  end

  describe "#submit" do

    let(:request_uri) { "some/request/uri" }
    let(:request_headers) { { "header_key" => "header_value" } }
    let(:request) { double(AccountRight::API::Request, uri: request_uri, headers: request_headers) }

    before(:each) { AccountRight::API::Request.stub!(:new).and_return(request) }

    it "should perform a HTTP GET for the resource with the requests headers" do
      HTTParty.should_receive(:get).with(request_uri, headers: request_headers)

      AccountRight::API::QueryCommand.new(resource_path, security_tokens).submit
    end

    it "should return the GET request response" do
      response = double("HttpResponse", code: 200, body: "some body")
      HTTParty.stub!(:get).and_return(response)

      AccountRight::API::QueryCommand.new(resource_path, security_tokens).submit.should eql(response)
    end

  end

  describe "#security_tokens" do

    let(:request) { double(AccountRight::API::Request) }

    before(:each) { AccountRight::API::Request.stub!(:new).and_return(request) }

    it "should return the tokens from the request" do
      request.should_receive(:security_tokens).and_return(security_tokens)

      AccountRight::API::QueryCommand.new(resource_path, security_tokens).security_tokens.should eql(security_tokens)
    end

  end

end
