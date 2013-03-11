require File.expand_path('../../../lib/account_right_mobile/services', __FILE__)

CUCUMBER_CONFIGURATION = nil

AfterConfiguration { |config| CUCUMBER_CONFIGURATION = config }

Before do
  api_service_class = CUCUMBER_CONFIGURATION.filters.include?("@smoke") ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::ApiStubConfigurer
  @api_service = api_service_class.new
  @api_service.return_some_files
end

Before do
  oauth_service_class = CUCUMBER_CONFIGURATION.filters.include?("@smoke") ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::OAuthStubConfigurer
  @oauth_service = oauth_service_class.new
  @oauth_service.grant_access
end
