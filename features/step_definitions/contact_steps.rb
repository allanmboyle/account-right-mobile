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

When /^the user accesses the Contacts Details$/ do
  @current_page.access_a_contact
end

Then /^the Contacts page for the Customer File should be shown$/ do
  step "the Contacts page should be shown"
  @current_page.customer_file_name.should eql(@accessed_customer_file_name)
end

Then /^all the Contacts are shown$/ do
  expected_contacts = (to_overview_fragments(@customers, "Customer") +
                       to_overview_fragments(@suppliers, "Supplier")).sort_by { |contact| contact.name }
  @current_page.contacts.should eql(expected_contacts)
end

Then /^a message should be displayed indicating the file contains no contacts$/ do
  @current_page.should have_no_contacts_available_message
end

Then /^the (.*) of the contact should be shown$/ do |field_description|
  field = to_field_symbol(field_description)
  @expected_contact ||= to_detail_fragment(@contact, @contact_type)
  @current_page.contact.send(field).should eql(@expected_contact.send(field))
end

Then /^no (.*) should be shown$/ do |field_description|
  @current_page.contact.send(to_field_symbol(field_description)).should be_empty
end

def to_field_symbol(description)
  description.gsub(/\s/, "_").to_sym
end

def to_overview_fragments(api_models, type)
  api_models.map do |model|
    AccountRightMobile::Acceptance::Pages::Fragments::ContactOverview.from_api_model(model, type)
  end
end

def to_detail_fragment(api_model, type)
  AccountRightMobile::Acceptance::Pages::Fragments::ContactDetail.from_api_model(api_model, type)
end
