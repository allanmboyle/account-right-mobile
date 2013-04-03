describe ApiController, type: :controller do

  describe "#invoke" do

    describe "when a json request is made" do

      let(:access_token) { "some_access_token" }
      let(:resource_path) { "some/resource/path" }

      before(:each) { session[:access_token] = access_token }

      it "should invoke the API with the users session which contains security tokens" do
        AccountRight::API.should_receive(:invoke).with(resource_path, session)

        get_invoke
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
        request_action resource_path: resource_path, format: :json
      end

    end

    it_should_behave_like "an action that only accepts json"

    def request_action(options)
      get :invoke, options
    end

  end

end
