Given /^the API is unable to return contacts data due to an arbitrary problem$/ do
  @api_service.return_contacts_error
end

When /^the Customer File contains multiple contacts$/ do
  @customers = [ { CoLastName: "Visy", FirstName: "", IsIndividual: false, CurrentBalance: -25000.00 },
                 { CoLastName: "Nexus", FirstName: "Ingrid", IsIndividual: true, CurrentBalance: 15000.00 },
                 { CoLastName: "Visible Gap", FirstName: "", IsIndividual: false, CurrentBalance: 975.00 } ]
  @api_service.return_customers(@customers)
  @suppliers = [ { CoLastName: "Dell Inc.", FirstName: "", IsIndividual: false, CurrentBalance: 75000.00 },
                 { CoLastName: "Nique", FirstName: "Pitch", IsIndividual: true, CurrentBalance: -5000.00 },
                 { CoLastName: "HighTense Corp.", FirstName: "", IsIndividual: false, CurrentBalance: 201.00 } ]
  @api_service.return_suppliers(@suppliers)
end

When /^the Customer File contains no contacts$/ do
  @api_service.return_no_contacts
end

Then /^all the Contacts are shown$/ do
  contacts_expected = (to_page_contacts(@customers, "Customer") +
                       to_page_contacts(@suppliers, "Supplier")).sort_by { |contact| contact[:name] }
  @current_page.contacts.should eql(contacts_expected)
end

Then /^a message should be displayed indicating the file contains no contacts$/ do
  @current_page.should have_no_contacts_available_message
end

def to_page_contacts(api_contacts, type)
  api_contacts.map do |api_contact|
    name = "#{api_contact[:CoLastName]}#{api_contact[:IsIndividual] ? ", #{api_contact[:FirstName]}" : ""}"
    balance_first_word = api_contact[:CurrentBalance] < 0 ? "I" : "They"
    balance = "#{balance_first_word} owe #{sprintf("%.2f", api_contact[:CurrentBalance].abs)}"
    { name: name, type: type, balance: balance }
  end
end
