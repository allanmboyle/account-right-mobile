require File.expand_path('../../../lib/account_right_mobile/services', __FILE__)

CUCUMBER_CONFIGURATION = nil

AfterConfiguration { |config| CUCUMBER_CONFIGURATION = config }

Before do
  api_service_class = CUCUMBER_CONFIGURATION.filters.include?("@smoke") ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::ApiStubConfigurer
  api_service_class.initialize!
  @api_service = api_service_class.new
end

Before do
  oauth_service_class = CUCUMBER_CONFIGURATION.filters.include?("@smoke") ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::OAuthStubConfigurer
  oauth_service_class.initialize!
  @oauth_service = oauth_service_class.new
end
