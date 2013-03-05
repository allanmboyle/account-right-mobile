require File.expand_path('../../../lib/account_right_mobile/services', __FILE__)

CUCUMBER_CONFIGURATION = nil

Before do
  oauth_service_class = CUCUMBER_CONFIGURATION.filters.include?("@smoke") ?
      AccountRightMobile::Services::NoOpService : AccountRightMobile::Services::OAuthStubConfigurer
  @oauth_service = oauth_service_class.new
  @oauth_service.grant_access
end

AfterConfiguration { |config| CUCUMBER_CONFIGURATION = config }
