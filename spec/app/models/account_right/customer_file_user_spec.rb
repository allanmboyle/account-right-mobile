describe AccountRight::CustomerFileUser do

  let(:username) { "some_username" }
  let(:password) { "some_password" }
  let(:customer_file_user) { AccountRight::CustomerFileUser.new(username: username, password: password) }

  it "should consist of a username" do
    customer_file_user.username.should eql(username)
  end

  it "should consist of a password" do
    customer_file_user.password.should eql(password)
  end

  describe "#cf_token" do

    it "should return the username and password encoded in RFC 4648 compliant base64" do
      customer_file_user.cf_token.should eql(Base64.strict_encode64("#{username}:#{password}"))
    end

  end

  describe "#login" do

    let(:access_token) { "some-access-token" }
    let(:cf_token) { "some token" }
    let(:user_tokens) { AccountRight::UserTokensFactory.create(access_token: access_token) }
    let(:customer_file_id) { "0123456789" }

    before(:each) do
      customer_file_user.stub!(:cf_token).and_return(cf_token)

      AccountRight::API.stub!(:invoke).and_return("some response body")
    end

    it "should include the users customer file token in the users tokens" do
      process_request

      user_tokens[:cf_token].should eql(cf_token)
    end

    it "should request the accounting properties of the provided customer file from the api" do
      AccountRight::API.should_receive(:invoke).with("accountright/0123456789/AccountingProperties", user_tokens)

      process_request
    end

    it "should return the result of the api call" do
      process_request.should eql("some response body")
    end

    it "should raise an authentication failure when an authorization failure is thrown invoking the api" do
      forced_error = AccountRight::API::AuthorizationFailure.new(double("HttpResponse", body: "some message"))
      AccountRight::API.stub!(:invoke).and_raise(forced_error)

      lambda { process_request }.should raise_error(AccountRight::AuthenticationFailure)
    end

    it "should raise an authentication error when an error is thrown invoking the api" do
      forced_error = AccountRight::API::Error.new(double("HttpResponse", code: 500, body: "some message"))
      AccountRight::API.stub!(:invoke).and_raise(forced_error)

      lambda { process_request }.should raise_error(AccountRight::AuthenticationError)
    end

    def process_request
      customer_file_user.login(customer_file_id, user_tokens)
    end

  end

end
