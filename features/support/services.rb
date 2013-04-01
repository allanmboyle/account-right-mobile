require File.expand_path('../../../lib/account_right_mobile/services', __FILE__)

AfterConfiguration { |config| SMOKE_TEST_RUNNING = config.filters.include?("@smoke") }

Before do
  oauth_service_class = SMOKE_TEST_RUNNING ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::OAuthStubConfigurer
  oauth_service_class.initialize!
  @oauth_service = @authentication_service = oauth_service_class.new

  api_service_class = SMOKE_TEST_RUNNING ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::ApiStubConfigurer
  api_service_class.initialize!
  @api_service = api_service_class.for_headers("Authorization" => "Bearer #{@oauth_service.last_access_token}")
end
