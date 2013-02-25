describe AccountRightMobile::Config, "effects on the Rails configuration" do

  it "should alter the Rails configuration so that it includes the top level settings from the custom configuration" do
    expected_test_live_login_settings = { "base_uri" => "http://localhost:3002",
                                          "grant_type" => "password",
                                          "path" => "/oauth2/v1/authorise" }

    AccountRightMobile::Application.config.live_login.should include(expected_test_live_login_settings)
  end

end
