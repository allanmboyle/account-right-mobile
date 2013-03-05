Feature: Authenticated AccountRight Live Access
  In order to secure access to data
  As a user
  I want access to AccountRight Live to be authenticated

  @smoke
  Scenario: Access is granted when valid credentials are provided
    Given the user visits the AccountRight Live Login page
    And the user enters valid login credentials
    When the user attempts to login
    Then the Customer Files page should be shown

  Scenario: Error is shown when invalid credentials are provided
    Given the user visits the AccountRight Live Login page
    And the user enters invalid login credentials
    When the user attempts to login
    Then the AccountRight Live Login page should be shown
    And an error should be displayed indicating the provided credentials were invalid

  Scenario: Error is shown when authentication provider is unavailable
    Given the AccountRight Live authentication service is unavailable
    And the user visits the AccountRight Live Login page
    And the user enters valid login credentials
    When the user attempts to login
    Then the AccountRight Live Login page should be shown
    And an error should be displayed indicating application is unavailable

  Scenario: Error is shown when integration with the provider is mis-configured
    Given the AccountRight Live authentication service is mis-configured
    And the user visits the AccountRight Live Login page
    And the user enters valid login credentials
    When the user attempts to login
    Then the AccountRight Live Login page should be shown
    And an error should be displayed indicating application is unavailable
