When /^the user has chosen to access a Customer File$/ do
  @current_page.access_a_file
  step "the Customer File Login page should be shown"
end
