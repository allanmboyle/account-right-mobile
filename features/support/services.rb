require File.expand_path('../../../lib/account_right_mobile/services', __FILE__)

AfterConfiguration { |config| SMOKE_TEST_RUNNING = config.filters.include?("@smoke") }

Before do
  oauth_service_class = SMOKE_TEST_RUNNING ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::OAuthStub::Configurer
  oauth_service_class.initialize!
  @oauth_service = @authentication_service = oauth_service_class.new

  api_service_class = SMOKE_TEST_RUNNING ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::ApiStub::Configurer
  api_service_class.initialize!
  @api_service = api_service_class.new
end
