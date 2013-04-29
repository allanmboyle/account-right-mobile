describe TestableApplicationController, type: :controller do

  it "should expose Authentication Filters for use within controllers" do
    controller.should be_a_kind_of(AuthenticationFilters)
  end

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

  describe "#handle_unexpected_exception" do

    it "should respond with a body containing a description of the exception" do
      post :action_causing_exception, format: :json

      response.body.should eql("Some general exception")
    end

    it "should notify the Rails logger that an unexpected exception occurred" do
      Rails.logger.should_receive(:error).with(/an unexpected exception occurred/i)

      post :action_causing_exception, format: :json
    end

    it "should log the description of the exception" do
      Rails.logger.should_receive(:error).with(/Some general exception/)

      post :action_causing_exception, format: :json
    end

    it "should log the backtrace of the exception" do
      method_on_callstack = "action_causing_exception"
      Rails.logger.should_receive(:error).with(/#{method_on_callstack}/)

      post :action_causing_exception, format: :json
    end

  end

end
