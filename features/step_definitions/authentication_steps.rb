Given /^the user enters valid log in credentials$/ do
  @authentication_service.grant_access
  if @authentication_service.is_a?(AccountRight::OAuth::Stub::Configurer)
    @api_service.with_headers("Authorization" => "Bearer #{@oauth_service.last_access_token}")
  end
  @current_page.enter_credentials
end

Given /^the user enters invalid log in credentials$/ do
  @authentication_service.deny_access
  @current_page.enter_credentials
end

Given /^the user logs-in with valid credentials$/ do
  step "the user enters valid log in credentials"
  step "the user attempts to log in"
end

Given /^the user has logged-in to AccountRight Live$/ do
  step "the user visits the AccountRight Live log in page"
  step "the user logs-in with valid credentials"
  step "the Customer Files page should be shown"
end

Given /^the AccountRight Live authentication service is unavailable$/ do
  @oauth_service.unavailable
end

Given /^the AccountRight Live authentication service is mis-configured/ do
  @oauth_service.misconfigure
end

Given /^the users AccountRight Live log in has expired$/ do
  @api_service.deny_access_for_current_headers
  @oauth_service.grant_access
end

When /^the user attempts to log in$/ do
  @current_page.login
end

When /^the user logs-in to AccountRight Live$/ do
  step "the user has logged-in to AccountRight Live"
end

When /^the user logs-out.*$/ do
  @current_page.logout
end

Given /^the users session has expired$/ do
  session_cookie = @session.get_cookie("_account-right-mobile_session")
  session_cookie[:expires] = DateTime.parse(1.minute.ago.to_s)
  @session.add_cookie(session_cookie)
end

Then /^an error should be displayed indicating the provided credentials were invalid$/ do
  @current_page.should have_invalid_credentials_message
end

Then /^an error should be displayed indicating an error occurred during authentication/ do
  @current_page.should have_authentication_error_message
end

Then /^a message should be displayed indicating the user must log in to continue$/ do
  @current_page.should have_login_required_message
end
