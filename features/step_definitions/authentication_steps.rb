Given /^the user enters valid login credentials$/ do
  @current_page.enter_credentials
end

Given /^the user enters invalid login credentials$/ do
  @authentication_service.deny_access
  @current_page.enter_credentials
end

Given /^the user logs-in with valid credentials/ do
  step "the user enters valid login credentials"
  step "the user attempts to login"
end

Given /^the user has logged-in to AccountRight Live$/ do
  step "the user visits the AccountRight Live Login page"
  step "the user logs-in with valid credentials"
  step "the Customer Files page should be shown"
end

Given /^the AccountRight Live authentication service is unavailable$/ do
  @oauth_service.unavailable
end

Given /^the AccountRight Live authentication service is mis-configured/ do
  @oauth_service.misconfigure
end

When /^the user attempts to login$/ do
  @current_page.login
end

When /^the user logs-in to AccountRight Live$/ do
  step "the user has logged-in to AccountRight Live"
end

Then /^an error should be displayed indicating the provided credentials were invalid$/ do
  @current_page.should have_invalid_login_message
end
