Feature: User session management
  In order to better secure my data
  As a user
  I want my log in to expire after a period of inactivity

  @wip
  Scenario: User successfully re-logs-in even though session has expired
    Given the user visits the AccountRight Live log in page
    And the users session has expired
    And the user logs-in with valid credentials
    And the Customer Files page is shown
    When the user logs-in to a Customer File
    Then the Contacts page should be shown

  @wip
  Scenario: User is redirected to homepage when interacting with secure page after session has expired
    Given the user has logged-in to AccountRight Live
    And the users session has expired
    When the user logs-in to a Customer File
    Then the AccountRight Live log in page should be shown
    And a message should be displayed indicating the user must re-log in to continue

  @wip
  Scenario: User is redirected to homepage when refreshing secure page after session has expired
    Given the user has logged-in to AccountRight Live
    And the users session has expired
    When the user refreshes the page
    Then the AccountRight Live log in page should be shown
    And a message should be displayed indicating the user must log in to continue
