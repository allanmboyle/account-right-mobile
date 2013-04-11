Feature: Display Contact Details
  In order to contact and discover information about customers and suppliers
  As a user
  I want to be able to view details about a customer or supplier

@wip
Scenario: Contact contains comprehensive set of data
  Given the user intends to access a Contact with a comprehensive set of data
  And the user has accessed a Customer File
  When the user accesses the Contacts Details
  Then the Contact Details page should be shown
  And the name of the contact should be shown
  And the type of the contact should be shown
  And the balance of the contact should be shown
  And the phone numbers of the contact should be shown
  And the email address of the contact should be shown
  And the address of the contact should be shown

@wip
Scenario: Contact contains minimal data
  Given the user intends to access a Contact with a minimal set of data
  And the user has accessed a Customer File
  When the user accesses the Contacts Details
  Then the Contact Details page should be shown
  And the name of the contact should be shown
  And the type of the contact should be shown
  And the balance of the contact should be shown
  And no phone numbers should be shown
  And no email address should be shown
  And no address should be shown
