describe TestableApplicationController, type: :controller do

  describe "#establish_client_application_state" do

    it "should create client application state encapsulating data in the users session" do
      AccountRightMobile::ClientApplicationState.should_receive(:new).with(session)

      controller.establish_client_application_state
    end

    it "should establish the client application state as an instance variable accessible within actions" do
      client_application_state = double(AccountRightMobile::ClientApplicationState)
      AccountRightMobile::ClientApplicationState.stub!(:new).with(session).and_return(client_application_state)

      controller.establish_client_application_state

      assigns(:client_application_state).should eql(client_application_state)
    end

    it "should be executed before each action" do
      controller.should_receive(:establish_client_application_state)

      post :some_action, format: :json
    end

  end

  describe "#respond_to_json" do

    describe "when a json response is requested" do

      it "should respond with the JSON content" do
        post :some_action, format: :json

        response.body.should eql("Some JSON")
      end

    end

    describe "when a non-JSON request is issued" do

      it "should respond with a status indicating the requested response type is not acceptable" do
        post :some_action, format: :html

        response.status.should eql(406)
      end

    end

  end

end
