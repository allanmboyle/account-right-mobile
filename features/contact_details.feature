Feature: Display Contact details
  In order to contact and discover information about customers and suppliers
  As a user
  I want to be able to view details about a customer or supplier

Scenario: Contact contains comprehensive set of data
  Given the user intends to access a Contact with a comprehensive set of data
  And the user has accessed a Customer File
  When the user accesses the Contacts Details
  Then the Contact details page for the Customer File should be shown without error
  And the name of the contact should be shown
  And the type of the contact should be shown
  And the balance of the contact should be shown
  And the phone numbers of the contact should be shown
  And the user should be able to call the phone numbers via a tap
  And the email address of the contact should be shown
  And the user should be able to send a message to the email address via tap
  And the address of the contact should be shown

Scenario: Contact contains minimal data
  Given the user intends to access a Contact with a minimal set of data
  And the user has accessed a Customer File
  When the user accesses the Contacts Details
  Then the Contact details page for the Customer File should be shown without error
  And the name of the contact should be shown
  And the type of the contact should be shown
  And the balance of the contact should be shown
  And no phone numbers of the contact should be shown
  And no email address of the contact should be shown
  And no address of the contact should be shown

Scenario: Return to Contacts List
  Given the user has accessed a Contacts Details
  When the user navigates back
  Then the Contacts page should be shown without error
