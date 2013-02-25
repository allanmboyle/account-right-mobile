describe AccountRight::LiveUser, "integrating with an oAuth server" do
  include_context "integration with an oAuth stub server"

  before(:all) {  force_server_start! }

  after(:all) { force_server_stop! }

  let(:oauth_service) { AccountRightMobile::OAuthStubConfigurer.new }
  let(:live_user) { AccountRight::LiveUser.new(username: "someUsername", password: "somePassword") }

  describe "#login" do

    describe "when the server allows the log-in attempt for a specific user" do

      before(:each) { oauth_service.grant_access_for(username: live_user.username, password: live_user.password) }

      it "should return the access and refresh token returned by the oAuth service" do
        live_user.login.should eql(access_token: "test_access_token", refresh_token: "test_refresh_token")
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
