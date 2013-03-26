describe AccountRight::API, "integrating with an API server" do
  include_context "integration with an API stub server"

  let(:api_key) { "some_api_key" }
  let(:authorization_token) { "some_oauth_token" }
  let(:resource_path) { "a_resource" }
  let(:json_response) { { "Key" => "Value" }.to_json }
  let(:stub_options) { { method: :get, response: { status: 200, body: json_response } } }
  let(:api_service) { AccountRightMobile::Services::ApiStubConfigurer }

  before(:each) { force_server_start! }

  before(:each) do
    @original_api_config = AccountRightMobile::Application.config.api.clone
    AccountRightMobile::Application.config.api =
        AccountRightMobile::Application.config.api.merge({ "key" => api_key })
  end

  after(:each) { AccountRightMobile::Application.config.api = @original_api_config }

  after(:each) { force_server_stop! }

  describe "#invoke" do

    describe "when the server responds with json" do

      it "should request compressed data from the api" do
        api_service.for_headers("Accept-Encoding" => "gzip,deflate").stub_response!("/#{resource_path}", stub_options)

        AccountRight::API.invoke(resource_path, authorization_token).should_not be_empty
      end

      it "should issue requests to the api with an authorization header that includes the oAuth token" do
        api_service.for_headers("Authorization" => "Bearer #{authorization_token}")
        .stub_response!("/#{resource_path}", stub_options)

        AccountRight::API.invoke(resource_path, authorization_token).should_not be_empty
      end

      it "should issue requests to the api with the configured API key" do
        api_service.for_headers("x-myobapi-key" => api_key).stub_response!("/#{resource_path}", stub_options)

        AccountRight::API.invoke(resource_path, authorization_token).should_not be_empty
      end

      it "should return the API's JSON response" do
        api_service.stub_response!("/#{resource_path}", stub_options)

        AccountRight::API.invoke(resource_path, authorization_token).should eql(json_response)
      end

    end

    describe "and a customer file token is provided" do

      let(:customer_file_token) { "some_customer_file_token" }

      it "should issue requests to the api with a customer file token header that includes the token" do
        api_service.for_headers("x-myobapi-cftoken" => customer_file_token).stub_response!("/#{resource_path}", stub_options)

        AccountRight::API.invoke(resource_path, authorization_token, customer_file_token).should_not be_empty
      end

    end

  end

end
