require File.expand_path('../../../lib/account_right_mobile/services', __FILE__)

AfterConfiguration { |config| SMOKE_TEST_RUNNING = config.filters.include?("@smoke") }

Before do
  oauth_service_class = SMOKE_TEST_RUNNING ?
      AccountRightMobile::Services::NoOpService : AccountRight::OAuth::Stub::Configurer
  oauth_service_class.server_has_started!
  oauth_service_class.reset!
  @oauth_service = @authentication_service = oauth_service_class.new
  @oauth_service.grant_access

  api_service_class = SMOKE_TEST_RUNNING ?
      AccountRightMobile::Services::NoOpService : AccountRight::API::Stub::Configurer
  api_service_class.server_has_started!
  api_service_class.reset!
  @api_service = api_service_class.new
  @api_service.with_headers("Authorization" => "Bearer #{@oauth_service.last_access_token}").grant_access

  @api_data_factory = AccountRight::API::DataFactory
end
