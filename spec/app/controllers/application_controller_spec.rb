describe TestableApplicationController, type: :controller do

  describe "#establish_client_application_state" do

    it "should be executed before each action" do
      controller.should_receive(:establish_client_application_state)

      post :empty_action, format: :json
    end

    it "should create client application state encapsulating data in the users session" do
      AccountRightMobile::ClientApplicationState.should_receive(:new).with(session)

      post :empty_action, format: :json
    end

    it "should establish the client application state as an instance variable accessible within actions" do
      client_application_state = double(AccountRightMobile::ClientApplicationState)
      AccountRightMobile::ClientApplicationState.stub!(:new).with(session).and_return(client_application_state)

      post :empty_action, format: :json

      assigns(:client_application_state).should eql(client_application_state)
    end


  end

  describe "#require_live_login" do

    let(:client_application_state) { double(AccountRightMobile::ClientApplicationState) }

    before(:each) { AccountRightMobile::ClientApplicationState.stub!(:new).and_return(client_application_state) }

    describe "when the client application state indicates the user has logged-in to AccountRight Live" do

      before(:each) { client_application_state.stub!(:logged_in_to_live?).and_return(true) }

      it "should allow the action to be executed as normal" do
        post :action_requiring_live_login, format: :json

        response.body.should eql("Normal body")
      end

    end

    describe "when the client application state indicates the user has not logged-in to AccountRight Live" do

      before(:each) { client_application_state.stub!(:logged_in_to_live?).and_return(false) }

      it "should respond with a status of 401 indicating the request was unauthorised" do
        post :action_requiring_live_login, format: :json

        response.status.should eql(401)
      end

      it "should respond with a body indicating an AccountRight Live login is required" do
        post :action_requiring_live_login, format: :json

        response.body.should eql({ liveLoginRequired: true}.to_json)
      end

    end

  end

  describe "#respond_to_json" do

    describe "when a json response is requested" do

      it "should respond with the JSON content" do
        post :respond_to_json_action, format: :json

        response.body.should eql("Some JSON")
      end

    end

    describe "when a non-JSON request is issued" do

      it "should respond with a status indicating the requested response type is not acceptable" do
        post :respond_to_json_action, format: :html

        response.status.should eql(406)
      end

    end

  end

  describe "#default_json_response" do

    it "should return the current cross-site request forgery token" do
      post :action_with_default_json_response, format: :json

      response.body.should eql({ "csrf-token" => session[:_csrf_token] }.to_json)
    end

  end

end
