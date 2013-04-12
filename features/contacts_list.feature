Feature: List Contacts
  In order to contact and discover information about customers and suppliers
  As a user
  I want to be able to view customer and supplier data

Scenario: Customer File contains multiple contacts
  Given the user has logged-in to AccountRight Live
  When the user logs-in to a Customer File with multiple contacts
  Then the Contacts page for the Customer File should be shown
  And all the Contacts are shown

Scenario: Customer File contains no contacts
  Given the user has logged-in to AccountRight Live
  When the user logs-in to a Customer File with no contacts
  Then the Contacts page for the Customer File should be shown
  And a message should be displayed indicating the file contains no contacts

Scenario: Error is shown when an unexpected API error occurs
  Given the API is unable to return contacts data due to an arbitrary problem
  And the user has logged-in to AccountRight Live
  When the user logs-in to a Customer File
  Then the Contacts page should be shown
  And an error should be displayed indicating the application is unavailable
