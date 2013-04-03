describe AccountRight::LiveUser, "integrating with an oAuth server" do
  include_context "integration with an oAuth stub server"

  let(:client_id) { "some_client_id" }
  let(:client_secret) { "some_client_secret" }
  let(:grant_type) { "some_grant_type" }
  let(:scope) { "some_scope" }
  let(:oauth_service) { AccountRightMobile::Services::OAuthStubConfigurer.new }
  let(:live_user) { AccountRight::LiveUser.new(username: "some_username", password: "some_password") }

  before(:each) { force_server_start! }

  before(:each) do
    @original_live_login_config = AccountRightMobile::Application.config.live_login.clone
    AccountRightMobile::Application.config.live_login =
        AccountRightMobile::Application.config.live_login.merge({ "client_id" => client_id,
                                                                  "client_secret" => client_secret,
                                                                  "grant_type" => grant_type,
                                                                  "scope" => scope })
  end

  after(:each) { AccountRightMobile::Application.config.live_login = @original_live_login_config }

  after(:each) { force_server_stop! }

  describe "#login" do

    describe "when the server allows the log-in attempt for a given client and user" do

      before(:each) do
        oauth_service.grant_access_for(client_id: client_id, client_secret: client_secret, grant_type: grant_type,
                                       scope: scope, username: live_user.username, password: live_user.password)
      end

      it "should return the access and refresh token returned by the oAuth service" do
        result = live_user.login

        result.should eql(access_token: oauth_service.last_access_token,
                          refresh_token: oauth_service.last_refresh_token)
      end

    end

    describe "when the server denies log-in attempts" do

      before(:each) { oauth_service.deny_access }

      it "should raise an exception indicating the login failed" do
        lambda { live_user.login }.should raise_error(AccountRight::AuthenticationFailure)
      end

    end

    describe "when the server call fails as the oauth service is unavailable" do

      before(:each) { oauth_service.unavailable }

      it "should raise an exception indicating an error occurred during the login attempt" do
        lambda { live_user.login }.should raise_error(AccountRight::AuthenticationError)
      end

    end

    describe "when the server call fails as the oauth service is mis-configured" do

      before(:each) { oauth_service.misconfigure }

      it "should raise an exception indicating an error occurred during the login attempt" do
        lambda { live_user.login }.should raise_error(AccountRight::AuthenticationError)
      end

    end

  end

end
