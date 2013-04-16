Given /^the user has access to multiple Customer Files$/ do
  @customer_files = [ @api_data_factory.create_customer_file(),
                      @api_data_factory.create_customer_file(),
                      @api_data_factory.create_customer_file() ]
  @api_service.return_files(@customer_files)
end

Given /^the user has access to one Customer File$/ do
  @customer_file = configuration["customer_file"].symbolize_keys
  @api_service.return_files([@customer_file])
end

Given /^the user does not have access to any Customer File$/ do
  @api_service.return_no_files
end

Given /^the API is unable to return data due to an arbitrary problem$/ do
  @api_service.return_errors
end

Given /^the user has logged-in to a Customer File$/ do
  step "the user logs-in to a Customer File"
end

Given /^the user has accessed a Customer File$/ do
  step "the user has logged-in to AccountRight Live"
  step "the user has logged-in to a Customer File"
  step "the Contacts page is shown"
end

When /^the user has chosen to access a Customer File$/ do
  @accessed_customer_file_name = @current_page.access_a_file
  @authentication_service = @api_service
end

When /^the user logs-in to a Customer File$/ do
  step "the user has chosen to access a Customer File"
  step "the user logs-in with valid credentials"
end

When /^the user logs-in to a Customer File with (.*)$/ do |contacts_expression|
  step "the user has chosen to access a Customer File"
  step "the Customer File contains #{contacts_expression}"
  step "the user logs-in with valid credentials"
end

Then /^the Customer File log in is shown$/ do
  @current_page.shows_login_within?(@customer_file[:Name]).should be_true
end

Then /^the log in username should default to '([^']*)'$/ do |expected_username|
  @current_page.username.should eql(expected_username)
end

Then /^all the Customer Files are shown$/ do
  @current_page.customer_file_names.should eql(@customer_files.map { |file| file[:Name] })
end

Then /^the Customer File is shown$/ do
  @current_page.customer_file_names.should eql([@customer_file[:Name]])
end

Then /^the (.*) page for the Customer File should be shown$/ do |page_name|
  step "the #{page_name} page should be shown"
  @current_page.customer_file_name.should eql(@accessed_customer_file_name)
end

Then /^a message should be displayed indicating no customer files are available to access$/ do
  @current_page.should have_no_customer_files_available_message
end
