describe ApiController, type: :controller do

  describe "#invoke" do

    describe "GET" do

      describe "when a json request is made" do

        let(:access_token) { "some_access_token" }
        let(:resource_path) { "some/resource/path" }
        let(:client_application_state) { double(AccountRightMobile::ClientApplicationState) }

        before(:each) do
          AccountRightMobile::ClientApplicationState.stub!(:new).and_return(client_application_state)
          AccountRight::API.stub!(:invoke)
        end

        it "should create client application state encapsulating data in the users session" do
          AccountRightMobile::ClientApplicationState.should_receive(:new).with(session)
                                                                         .and_return(client_application_state)

          get_invoke
        end

        it "should invoke the API with the created client application state" do
          AccountRight::API.should_receive(:invoke).with(resource_path, client_application_state)

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

end
