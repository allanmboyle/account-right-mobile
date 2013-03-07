Then /^an error should be displayed indicating the application is unavailable$/ do
  @current_page.should have_application_unavailable_message
end
