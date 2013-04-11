Given /^the API is unable to return contacts data due to an arbitrary problem$/ do
  @api_service.return_contacts_error
end

Given /^the user intends to access a Contact with a comprehensive set of data$/ do
  @contact = @api_data_factory.create_company()
  @contact_type = "Customer"
  @api_service.return_contacts(customers: [@contact], suppliers: [])
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

Then /^all the Contacts are shown$/ do
  expected_contacts = (to_overview_fragments(@customers, "Customer") +
                       to_overview_fragments(@suppliers, "Supplier")).sort_by { |contact| contact.name }
  @current_page.contacts.should eql(expected_contacts)
end

Then /^a message should be displayed indicating the file contains no contacts$/ do
  @current_page.should have_no_contacts_available_message
end

Then /^the ([^\s]*) of the contact should be shown$/ do |field|
  @expected_contact ||= to_detail_fragment(@contact, @contact_type)
  @current_page.contact.send(field.to_sym).should eql(@expected_contact.send(field.to_sym))
end

Then /^the phone numbers of the contact should be shown$/ do
  step "the phone_numbers of the contact should be shown"
end

Then /^the email address of the contact should be shown$/ do
  step "the email_address of the contact should be shown"
end

def to_overview_fragments(api_models, type)
  api_models.map do |model|
    AccountRightMobile::Acceptance::Pages::Fragments::ContactOverview.from_api_model(model, type)
  end
end

def to_detail_fragment(api_model, type)
  AccountRightMobile::Acceptance::Pages::Fragments::ContactDetail.from_api_model(api_model, type)
end
