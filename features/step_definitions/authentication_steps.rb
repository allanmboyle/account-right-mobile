Given /^the user enters valid login credentials$/ do
  @oauth_service.grant_access
  @current_page.enter_credentials
end

Given /^the user enters invalid login credentials$/ do
  @oauth_service.deny_access
  @current_page.enter_credentials
end

When /^the user attempts to login$/ do
  @current_page.login
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

Then /^an error should be displayed indicating the provided credentials were invalid$/ do
  @current_page.shows_invalid_login_message!
end

Then /^an error should be displayed indicating application is unavailable$/ do
  @current_page.shows_application_unavailable_message!
end
