Given /^the API is unable to return contacts data due to an arbitrary problem$/ do
  @api_service.return_contacts_error
end

Given /^the user intends to access the established Contact$/ do
  @api_service.return_contacts(customers: [@contact], suppliers: [])
end

Given /^the user intends to access a Contact with a comprehensive set of data$/ do
  @contact = @api_data_factory.create_company()
  @contact_type = "Customer"
  step "the user intends to access the established Contact"
end

Given /^the user intends to access a Contact with a minimal set of data$/ do
  @contact = @api_data_factory.create_contact_with_minimal_data()
  @contact_type = "Customer"
  step "the user intends to access the established Contact"
end

Given /^the user has accessed a Contacts Details$/ do
  step "the user has accessed a Customer File"
  step "the user accesses a Contacts Details"
  step "the Contact details page is shown without error"
end

When /^the Customer File contains multiple contacts$/ do
  @customers = [ @api_data_factory.create_company(),
                 @api_data_factory.create_individual(),
                 @api_data_factory.create_company() ]
  @suppliers = [ @api_data_factory.create_company(),
                 @api_data_factory.create_individual(),
                 @api_data_factory.create_company() ]
  @api_service.return_contacts(customers: @customers, suppliers: @suppliers)
end

When /^the Customer File contains no contacts$/ do
  @api_service.return_no_contacts
end

When /^the user accesses (?:the|a) Contacts Details$/ do
  @current_page.access_a_contact
end

When /^the user filters by the first letters of a contacts name$/ do
  @filter_contact = @current_page.contacts[1]
  @current_page.filter(@filter_contact.name[0..2])
end

When /^the user filters by a contacts complete name$/ do
  @filter_contact = @current_page.contacts[1]
  @current_page.filter(@filter_contact.name)
end

Then /^all the Contacts are shown$/ do
  expected_contacts = (@current_page.to_fragments(@customers, "Customer") +
                       @current_page.to_fragments(@suppliers, "Supplier")).sort_by { |contact| contact.name }
  @current_page.contacts.should eql(expected_contacts)
end

Then /^a message should be displayed indicating the file contains no contacts$/ do
  @current_page.should have_no_contacts_available_message
end

Then /^the (.+) of the contact should be shown$/ do |field_description|
  field = to_field_symbol(field_description)
  @expected_contact ||= @current_page.to_fragment(@contact, @contact_type)
  @current_page.contact.send(field).should eql(@expected_contact.send(field))
end

Then /^the user should be able to call the phone numbers via a tap$/ do
  @current_page.contact.should have_callable_phone_numbers
end

Then /^the user should be able to send a message to the email address via tap$/ do
  @current_page.contact.should be_emailable
end

Then /^no (.+) of the contact should be shown$/ do |field_description|
  @current_page.contact.send(to_field_symbol(field_description)).should be_empty
end

Then /^that contact should be shown$/ do
  @current_page.contacts.should include(@filter_contact)
end

Then /^no other contacts name should be shown$/ do
  @current_page.contacts.should eql([@filter_contact])
end

def to_field_symbol(description)
  description.gsub(/\s/, "_").to_sym
end
