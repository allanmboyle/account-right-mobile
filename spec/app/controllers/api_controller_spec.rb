describe ApiController, type: :controller do

  describe "#invoke" do

    let(:access_token) { "some_access_token" }
    let(:resource_path) { "some/resource/path" }

    before(:each) { session[:access_token] = access_token }

    describe "when a customer file token has been established in the users session" do

      let(:customer_file_token) { "some_customer_file_token" }

      before(:each) { session[:cftoken] = customer_file_token }

      it "should also invoke the API with the users customer file token" do
        AccountRight::API.should_receive(:invoke).with(resource_path, access_token, customer_file_token)

        get_invoke
      end

    end

    describe "when a customer file token has not been established in the users session" do

      it "should invoke the API requesting the provided resource path with the users access token" do
        AccountRight::API.should_receive(:invoke).with(resource_path, access_token, nil)

        get_invoke
      end

    end

    describe "when the API responds with data" do

      before(:each) do
        AccountRight::API.stub!(:invoke).and_return("some json")
      end

      it "should respond with status of 200" do
        get_invoke

        response.status.should eql(200)
      end

      it "should return the response from the api" do
        get_invoke

        response.body.should eql("some json")
      end

    end

    def get_invoke
      get :invoke, resource_path: resource_path, format: :json
    end

  end

end
