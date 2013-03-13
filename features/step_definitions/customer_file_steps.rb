Given /^the user has access to multiple Customer Files$/ do
  @customer_files = ["Clearwater Pty Ltd", "Muddywater Pty Ltd", "BusyIzzy Cafe"]
  @api_service.return_files(@customer_files)
end

Given /^the user has access to one Customer File$/ do
  @customer_file = configuration["customer_file"]
  @api_service.return_files([@customer_file])
end

Given /^the user does not have access to any Customer File$/ do
  @api_service.return_no_files
end

Given /^the API is unable to return data due to an expected error$/ do
  @api_service.return_error
end

When /^the user has chosen to access a Customer File$/ do
  @current_page.access_a_file
end

When /^a message should be displayed indicating no customer files are available to access$/ do
  @current_page.should have_no_customer_files_available_message
end

Then /^all the Customer Files are shown$/ do
  @current_page.customer_files.should eql(@customer_files)
end

Then /^the Customer File is shown$/ do
  @current_page.customer_files.should eql([@customer_file])
end

Then /^the Customer File login is shown$/ do
  @current_page.shows_login_within?(@customer_file).should be_true
end
