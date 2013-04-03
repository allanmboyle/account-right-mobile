describe AccountRight::API::SimpleQueryExecutor, "integrating with an API server" do
  include_context "integration with an API stub server"

  let(:resource_path) { "a_resource" }
  let(:security_tokens) { { access_token: "some_oauth_token" } }
  let(:json_response) { { "Key" => "Value" }.to_json }
  let(:api_stub_options) { { method: :get, response: { status: 200, body: json_response } } }
  let(:api_service) { AccountRightMobile::Services::ApiStubConfigurer }

  before(:each) { force_server_start! }

  after(:each) { force_server_stop! }

  describe ".execute" do

    describe "when provided a query" do

      let(:query) { AccountRight::API::Query.new(resource_path, security_tokens) }

      it "should return the API's JSON response" do
        api_service.stub_response!("/#{resource_path}", api_stub_options)

        execute_query.should eql(json_response)
      end

      def execute_query
        AccountRight::API::SimpleQueryExecutor.execute(query)
      end

    end

  end

end
