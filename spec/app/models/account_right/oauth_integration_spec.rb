describe AccountRight::OAuth, "integrating with an oAuth server" do
  include_context "integration with an oAuth stub server"

  let(:client_id) { "some_client_id" }
  let(:client_secret) { "some_client_secret" }
  let(:oauth_service) { AccountRightMobile::Services::OAuthStubConfigurer.new }

  before(:each) do
    force_server_start!

    oauth_service.deny_access
  end

  before(:each) do
    @original_live_login_config = AccountRightMobile::Application.config.live_login.clone
    AccountRightMobile::Application.config.live_login =
        AccountRightMobile::Application.config.live_login.merge({ "client_id" => client_id,
                                                                  "client_secret" => client_secret })
  end

  after(:each) { AccountRightMobile::Application.config.live_login = @original_live_login_config }

  after(:each) { force_server_stop! }

  shared_examples_for "a login method with standard error behaviour" do

    describe "when the server denies log-in attempts" do

      before(:each) { oauth_service.deny_access }

      it "should raise an exception indicating the login failed" do
        lambda { process_request }.should raise_error(AccountRight::AuthenticationFailure)
      end

    end

    describe "when the server call fails as the oauth service is unavailable" do

      before(:each) { oauth_service.unavailable }

      it "should raise an exception indicating an error occurred during the login attempt" do
        lambda { process_request }.should raise_error(AccountRight::AuthenticationError)
      end

    end

    describe "when the server call fails as the oauth service is mis-configured" do

      before(:each) { oauth_service.misconfigure }

      it "should raise an exception indicating an error occurred during the login attempt" do
        lambda { process_request }.should raise_error(AccountRight::AuthenticationError)
      end

    end

  end

  describe "#login" do

    let(:grant_type) { "password" }
    let(:scope) { "CompanyFile" }
    let(:username) { "some_username" }
    let(:password) { "some_password" }

    describe "when the server allows the log-in attempt for a given client and user" do

      before(:each) do
        oauth_service.grant_access_for(client_id: client_id, client_secret: client_secret, grant_type: grant_type,
                                       scope: scope, username: username, password: password)
      end

      it "should return the access and refresh token returned by the oAuth service" do
        result = process_request

        result.should eql(access_token: oauth_service.last_access_token,
                          refresh_token: oauth_service.last_refresh_token)
      end

    end

    it_should_behave_like "a login method with standard error behaviour"

    def process_request
      AccountRight::OAuth.login(username, password)
    end

  end

  describe "#re_login" do

    let(:grant_type) { "refresh_token" }
    let(:refresh_token) { "some_refresh_token" }

    describe "when the server allows the refresh log-in attempt for a given client and refresh token" do

      before(:each) do
        oauth_service.grant_access_for(client_id: client_id, client_secret: client_secret,
                                       grant_type: grant_type, refresh_token: refresh_token)
      end

      it "should return the access and refresh token returned by the oAuth service" do
        result = process_request

        result.should eql(access_token: oauth_service.last_access_token,
                          refresh_token: oauth_service.last_refresh_token)
      end

    end

    it_should_behave_like "a login method with standard error behaviour"

    def process_request
      AccountRight::OAuth.re_login(refresh_token)
    end

  end

end
