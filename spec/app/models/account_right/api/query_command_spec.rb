describe AccountRight::API::QueryCommand do

  let(:resource_path) { "some/resource/path" }
  let(:client_application_state) { double(AccountRightMobile::ClientApplicationState) }

  let(:query_command) { AccountRight::API::QueryCommand.new(resource_path, client_application_state) }

  describe "constructor" do

    it "should compose a request containing the provided resource path and client application state" do
      AccountRight::API::Request.should_receive(:new).with(resource_path, client_application_state)

      query_command
    end

  end

  describe "#submit" do

    let(:request_uri) { "some/request/uri" }
    let(:request_headers) { { "header_key" => "header_value" } }
    let(:request) { double(AccountRight::API::Request, uri: request_uri, headers: request_headers) }

    before(:each) { AccountRight::API::Request.stub!(:new).and_return(request) }

    it "should perform a HTTP GET for the resource with the requests headers" do
      HTTParty.should_receive(:get).with(request_uri, headers: request_headers)

      query_command.submit
    end

    it "should return the GET request response" do
      response = double("HttpResponse", code: 200, body: "some body")
      HTTParty.stub!(:get).and_return(response)

      query_command.submit.should eql(response)
    end

  end

  describe "#client_application_state" do

    let(:request) { double(AccountRight::API::Request) }

    before(:each) { AccountRight::API::Request.stub!(:new).and_return(request) }

    it "should delegate to the request to retrieve the client application state" do
      request.should_receive(:client_application_state).and_return(client_application_state)

      query_command.client_application_state.should eql(client_application_state)
    end

  end

  describe "#to_s" do

    let(:request) { double(AccountRight::API::Request, to_s: "some request description") }

    before(:each) { AccountRight::API::Request.stub!(:new).and_return(request) }

    it "should return string representation of the request" do
      query_command.to_s.should eql("some request description")
    end

  end

end
