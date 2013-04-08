Feature: List Contacts
  In order to discover information about and contact by customers and suppliers
  As a user
  I want to be able to view customer and supplier data

Scenario: Customer File contains multiple contacts
  Given the user has logged-in to AccountRight Live
  When the user logs-in to a Customer File with multiple contacts
  Then the Contacts page should be shown
  And all the Contacts are shown

@wip
Scenario: Customer File contains no contacts
  Given the user has logged-in to AccountRight Live
  When the user logs-in to a Customer File with no contacts
  Then the Contacts page should be shown
  And a message should be displayed indicating the file contains no contacts

@wip
Scenario: Error is shown when an unexpected API error occurs
  Given the API is unable to return contacts data due to an arbitrary problem
  And the user has logged-in to AccountRight Live
  When the user logs-in to a Customer File
  Then an error should be displayed indicating the application is unavailable
