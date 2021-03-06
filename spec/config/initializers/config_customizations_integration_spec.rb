describe "config_customizations initializer" do

  it "should alter the Rails configuration so that it includes the top level settings from the custom configuration" do
    expected_test_live_login_settings = { "base_uri" => "http://localhost:3002",
                                          "path" => "/oauth2/v1/authorize",
                                          "client_id" => "clientidabcdefghijkmnopq" }

    AccountRightMobile::Application.config.live_login.should include(expected_test_live_login_settings)
  end

end
