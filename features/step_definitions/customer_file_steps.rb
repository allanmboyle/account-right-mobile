When /^the user has chosen to access a Customer File$/ do
  @current_page.access_a_file
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

When /^a message should be displayed indicating no customer files are available to access$/ do
  @current_page.should have_no_customer_files_available_message
end
