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
    let(:customer_file) { double(AccountRight::CustomerFile, accounting_properties: "some accounting properties") }

    before(:each) { customer_file_user.stub!(:cf_token).and_return(cf_token) }

    it "should include the users customer file token in the users tokens" do
      perform_login

      user_tokens[:cf_token].should eql(cf_token)
    end

    it "should request the accounting properties of the provided customer file" do
      customer_file.should_receive(:accounting_properties).with(user_tokens)

      perform_login
    end

    it "should return the customer files accounting properties" do
      perform_login.should eql("some accounting properties")
    end

    it "should raise an authentication failure when an authorization failure is thrown retrieving the properties" do
      forced_error = AccountRight::API::AuthorizationFailure.new(double("HttpResponse", body: "some message"))
      customer_file.stub!(:accounting_properties).and_raise(forced_error)

      lambda { perform_login }.should raise_error(AccountRight::AuthenticationFailure)
    end

    it "should raise an authentication error when an error is thrown invoking the api" do
      forced_error = AccountRight::API::ErrorFactory.create
      customer_file.stub!(:accounting_properties).and_raise(forced_error)

      lambda { perform_login }.should raise_error(AccountRight::AuthenticationError)
    end

    def perform_login
      customer_file_user.login(customer_file, user_tokens)
    end

  end

end
