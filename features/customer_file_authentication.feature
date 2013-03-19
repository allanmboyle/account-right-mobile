Feature: Authenticated Customer File Access
  In order to secure access to data
  As a user
  I want access to my Customer Files to be authenticated

  Scenario: Access is granted when valid credentials are provided
    Given the user has logged-in to AccountRight Live
    And the user has chosen to access a Customer File
    And the user enters valid login credentials
    When the user attempts to login
    Then the Contacts page should be shown

  @wip
  Scenario: Error is shown when invalid credentials are provided
    Given the user has logged-in to AccountRight Live
    And the user has chosen to access a Customer File
    When the user enters invalid login credentials
    Then the Customer Files page should be shown
    And an error should be displayed indicating the provided credentials were invalid

  @wip
  Scenario: Error is shown when an unexpected API error occurs
    Given the API is unable to return data due to an expected error
    And the user has logged-in to AccountRight Live
    And the user has chosen to access a Customer File
    And the user enters valid login credentials
    When the user attempts to login
    Then the Customer Files page should be shown
    And an error should be displayed indicating the application is unavailable
