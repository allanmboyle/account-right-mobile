Given /^the API is unable to return contacts data due to an arbitrary problem$/ do
  @api_service.return_contacts_error
end

Given /^the user intends to access a Contact with a comprehensive set of data$/ do
  @api_service.return_contact_with_all_data
end

When /^the Customer File contains multiple contacts$/ do
  @customers = [ @api_data_factory.create_company(),
                 @api_data_factory.create_individual(),
                 @api_data_factory.create_company() ]
  @api_service.return_customers(@customers)
  @suppliers = [ @api_data_factory.create_company(),
                 @api_data_factory.create_individual(),
                 @api_data_factory.create_company() ]
  @api_service.return_suppliers(@suppliers)
end

When /^the Customer File contains no contacts$/ do
  @api_service.return_no_contacts
end

When /^the user accesses the Contacts Details$/ do
  @current_page.access_a_contact
end

Then /^all the Contacts are shown$/ do
  contacts_expected = (to_page_contacts(@customers, "Customer") +
                       to_page_contacts(@suppliers, "Supplier")).sort_by { |contact| contact[:name] }
  @current_page.contacts.should eql(contacts_expected)
end

Then /^a message should be displayed indicating the file contains no contacts$/ do
  @current_page.should have_no_contacts_available_message
end

When /^the ([^\s]*) of the contact should be shown$/ do |field|
  @current_page.contact[field.to_sym].should eql(@contact[field.to_sym])
end

When /^the phone numbers of the contact should be shown$/ do
  step "the phone_numbers of the contact should be shown"
end

When /^the email address of the contact should be shown$/ do
  step "the email_address of the contact should be shown"
end

def to_page_contacts(api_contacts, type)
  api_contacts.map do |api_contact|
    name = "#{api_contact[:CoLastName]}#{api_contact[:IsIndividual] ? ", #{api_contact[:FirstName]}" : ""}"
    balance_first_word = api_contact[:CurrentBalance] < 0 ? "I" : "They"
    balance = "#{balance_first_word} owe #{sprintf("%.2f", api_contact[:CurrentBalance].abs)}"
    { name: name, type: type, balance: balance }
  end
end
