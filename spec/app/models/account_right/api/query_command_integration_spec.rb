describe AccountRight::API::QueryCommand, "integrating with an API server" do
  include_context "integration with an API stub server"

  let(:resource_path) { "a_resource" }
  let(:client_application_state) { AccountRightMobile::ClientApplicationState.new(access_token: "some_oauth_token") }
  let(:json_response) { { "response_key" => "response_value" }.to_json }
  let(:api_stub_options) { { method: :get, response: { status: 200, body: json_response } } }
  let(:api_service) { AccountRightMobile::Services::ApiStub::Configurer }

  before(:each) { force_server_start! }

  after(:each) { force_server_stop! }

  let(:command) { AccountRight::API::QueryCommand.new(resource_path, client_application_state) }

  describe "#submit" do

    it "should return the API's JSON response" do
      api_service.stub_response!("/#{resource_path}", api_stub_options)

      command.submit.should eql(json_response)
    end

  end

end
