require File.expand_path('../../../lib/account_right_mobile', __FILE__)

Before do
  @oauth_service = AccountRightMobile::OAuthStubClient.new
end
