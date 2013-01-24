Given /^the user enters valid login credentials$/ do
  @current_page.enter_credentials(username: "valid_user", password: "valid_password")
end

When /^the user attempts to login$/ do
  @current_page.login
end
