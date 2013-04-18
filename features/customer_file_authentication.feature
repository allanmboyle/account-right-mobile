Feature: Authenticated Customer File Access
  In order to secure access to data
  As a user
  I want access to my Customer Files to be authenticated

  Scenario: Username defaults to 'administrator'
    Given the user has logged-in to AccountRight Live
    When the user has chosen to access a Customer File
    Then the log in username should default to 'Administrator'

  @smoke
  Scenario: Access is granted when valid credentials are provided
    Given the user has logged-in to AccountRight Live
    And the user has chosen to access a Customer File
    And the user enters valid log in credentials
    When the user attempts to log in
    Then the Contacts page should be shown

  Scenario: Logout of Customer File
    Given the user has accessed a Customer File
    When the user logs-out of the Customer File
    Then the Customer Files page should be shown

  @wip
  Scenario: User must re-log in to view secure pages
    Given the user has logged-in to AccountRight Live
    When the user attempts to visit the Contacts page
    Then the Customer Files page should be shown
    And a message should be displayed indicating the user must re-log in to continue

  Scenario: Error is shown when invalid credentials are provided
    Given the user has logged-in to AccountRight Live
    And the user has chosen to access a Customer File
    And the user enters invalid log in credentials
    When the user attempts to log in
    Then the Customer Files page should be shown
    And an error should be displayed indicating the provided credentials were invalid

  Scenario: Error is shown when an unexpected API error occurs
    Given the user has logged-in to AccountRight Live
    And the user has chosen to access a Customer File
    And the user enters valid log in credentials
    And the API is unable to return data due to an arbitrary problem
    When the user attempts to log in
    Then the Customer Files page should be shown
    And an error should be displayed indicating an error occurred during authentication
