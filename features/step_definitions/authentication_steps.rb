Given /^the user enters valid login credentials$/ do
  @current_page.enter_valid_credentials
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
