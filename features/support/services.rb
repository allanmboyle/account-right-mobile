require File.expand_path('../../../lib/account_right_mobile/services', __FILE__)

Before do
  @oauth_service = AccountRightMobile::Services::OAuthStubConfigurer.new
  @oauth_service.grant_access
end
