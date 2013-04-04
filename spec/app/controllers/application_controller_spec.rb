describe TestableApplicationController, type: :controller do

  describe "#establish_user_tokens" do

    it "should create user tokens encapsulating the tokens in the users session" do
      AccountRight::UserTokens.should_receive(:new).with(session)

      controller.establish_user_tokens
    end

    it "should establish the user tokens as an instance variable accessible within actions" do
      user_tokens = double(AccountRight::UserTokens)
      AccountRight::UserTokens.stub!(:new).with(session).and_return(user_tokens)

      controller.establish_user_tokens

      assigns(:user_tokens).should eql(user_tokens)
    end

    it "should be executed before each action" do
      controller.should_receive(:establish_user_tokens)

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
