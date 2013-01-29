Feature: Authenticated Customer File Access
  In order to secure access to data
  As a user
  I want access to my Customer Files to be authenticated

  Scenario: Login with valid credentials navigates user to Contacts page
    Given the user has logged-in to AccountRight Live
    And the user has chosen to access a Customer File
    And the user enters valid login credentials
    When the user attempts to login
    Then the Contacts page should be shown
