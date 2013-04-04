describe AccountRight::API::QueryCommand do

  let(:resource_path) { "some/resource/path" }
  let(:user_tokens) { double(AccountRight::UserTokens) }

  describe "constructor" do

    it "should compose a request containing the provided resource path and user tokens" do
      AccountRight::API::Request.should_receive(:new).with(resource_path, user_tokens)

      AccountRight::API::QueryCommand.new(resource_path, user_tokens)
    end

  end

  describe "#submit" do

    let(:request_uri) { "some/request/uri" }
    let(:request_headers) { { "header_key" => "header_value" } }
    let(:request) { double(AccountRight::API::Request, uri: request_uri, headers: request_headers) }

    before(:each) { AccountRight::API::Request.stub!(:new).and_return(request) }

    it "should perform a HTTP GET for the resource with the requests headers" do
      HTTParty.should_receive(:get).with(request_uri, headers: request_headers)

      AccountRight::API::QueryCommand.new(resource_path, user_tokens).submit
    end

    it "should return the GET request response" do
      response = double("HttpResponse", code: 200, body: "some body")
      HTTParty.stub!(:get).and_return(response)

      AccountRight::API::QueryCommand.new(resource_path, user_tokens).submit.should eql(response)
    end

  end

  describe "#user_tokens" do

    let(:request) { double(AccountRight::API::Request) }

    before(:each) { AccountRight::API::Request.stub!(:new).and_return(request) }

    it "should return the tokens from the request" do
      request.should_receive(:user_tokens).and_return(user_tokens)

      AccountRight::API::QueryCommand.new(resource_path, user_tokens).user_tokens.should eql(user_tokens)
    end

  end

  describe "#to_s" do

    let(:request) { double(AccountRight::API::Request, to_s: "some request description") }

    before(:each) { AccountRight::API::Request.stub!(:new).and_return(request) }

    it "should return string representation of the request" do
      AccountRight::API::QueryCommand.new(resource_path, user_tokens).to_s.should eql("some request description")
    end

  end

end
