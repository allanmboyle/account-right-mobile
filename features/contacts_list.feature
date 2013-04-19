Feature: List Contacts
  In order to contact and discover information about customers and suppliers
  As a user
  I want to be able to view customer and supplier data

  Scenario: Customer File contains multiple contacts
    Given the user has logged-in to AccountRight Live
    When the user logs-in to a Customer File with multiple contacts
    Then the Contacts page for the Customer File should be shown without error
    And all the Contacts are shown

  Scenario: Customer File contains no contacts
    Given the user has logged-in to AccountRight Live
    When the user logs-in to a Customer File with no contacts
    Then the Contacts page for the Customer File should be shown without error
    And a message should be displayed indicating the file contains no contacts

  Scenario: Filter contacts by partial name
    Given the user has logged-in to AccountRight Live
    And the user logs-in to a Customer File with multiple contacts
    And the Contacts page is shown without error
    When the user filters by the first letters of a contacts name
    Then that contact should be shown

  Scenario: Filter contacts by complete name
    Given the user has logged-in to AccountRight Live
    And the user logs-in to a Customer File with multiple contacts
    And the Contacts page is shown without error
    When the user filters by a contacts complete name
    Then that contact should be shown
    And no other contacts name should be shown

  Scenario: Error is shown when an unexpected API error occurs
    Given the API is unable to return contacts data due to an arbitrary problem
    And the user has logged-in to AccountRight Live
    When the user logs-in to a Customer File
    Then the Contacts page should be shown
    And an error should be displayed indicating the application is unavailable
