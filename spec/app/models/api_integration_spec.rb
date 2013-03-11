describe AccountRight::API, "integrating with an API server" do
  include_context "integration with an API stub server"

  before(:all) {  force_server_start! }

  after(:all) { force_server_stop! }

  let(:api_key) { "some_api_key" }
  let(:authorization_token) { "some_oauth_token" }
  let(:api_service) { AccountRightMobile::Services::ApiStubConfigurer }

  before(:each) do
    @original_api_config = AccountRightMobile::Application.config.api.clone
    AccountRightMobile::Application.config.api =
        AccountRightMobile::Application.config.api.merge({ "key" => api_key })
  end

  after(:each) { AccountRightMobile::Application.config.api = @original_api_config }

  it "should request compressed data" do
    api_service.with("Accept-Encoding" => "gzip,deflate").return_files(["A file"])

    AccountRight::API.customer_files(authorization_token).should_not be_empty
  end

  describe "#customer_files" do

    describe "when the server responds with multiple customer files" do

      let(:customer_file_names) { ["File 1", "File 2", "File 3"] }

      before(:each) do
        api_service.with("Authorization" => authorization_token, "x-myobapi-key" => api_key)
                   .return_files(customer_file_names)
      end

      it "should return the json representation of the files" do
        expected_result = customer_file_names.map { |name| { "Name" => name } }.to_json

        AccountRight::API.customer_files(authorization_token).should eql(expected_result)
      end

    end

  end

end
