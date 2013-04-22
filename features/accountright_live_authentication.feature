Feature: Authenticated AccountRight Live Access
  In order to secure access to data
  As a user
  I want access to AccountRight Live to be authenticated

  @smoke
  Scenario: Access is granted when valid credentials are provided
    Given the user visits the AccountRight Live log in page
    And the user enters valid log in credentials
    When the user attempts to log in
    Then the Customer Files page should be shown without error

  Scenario: Logout of AccountRight Live
    Given the user has logged-in to AccountRight Live
    And the Customer Files page is shown without error
    When the user logs-out
    Then the AccountRight Live log in page should be shown without error

  Scenario: User must re-log in when attempting to land on secure page
    When the user attempts to visit the Contacts page
    Then the AccountRight Live log in page should be shown without error
    And a message should be displayed indicating the user must re-log in to continue

  Scenario: User must re-log when attempting to navigate to secure page from the log in page
    Given the user visits the AccountRight Live log in page
    When the user attempts to visit the Contacts page
    Then the AccountRight Live log in page should be shown without error
    And a message should be displayed indicating the user must re-log in to continue

  Scenario: User is automatically re-logged-in when AccountRight Live log in expires
    Given the user has logged-in to AccountRight Live
    And the Customer Files page is shown without error
    And the users AccountRight Live log in has expired
    When the user logs-in to a Customer File
    Then the Contacts page should be shown without error

  Scenario: Error is shown when invalid credentials are provided
    Given the user visits the AccountRight Live log in page
    And the user enters invalid log in credentials
    When the user attempts to log in
    Then the AccountRight Live log in page should be shown
    And an error should be displayed indicating the provided credentials were invalid

  Scenario: Error is shown when authentication provider is unavailable
    Given the user visits the AccountRight Live log in page
    And the user enters valid log in credentials
    And the AccountRight Live authentication service is unavailable
    When the user attempts to log in
    Then the AccountRight Live log in page should be shown
    And an error should be displayed indicating an error occurred during authentication

  Scenario: Error is shown when integration with the provider is mis-configured
    Given the user visits the AccountRight Live log in page
    And the user enters valid log in credentials
    And the AccountRight Live authentication service is mis-configured
    When the user attempts to log in
    Then the AccountRight Live log in page should be shown
    And an error should be displayed indicating an error occurred during authentication
