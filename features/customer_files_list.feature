Feature: List Customer Files
  In order to access my data
  As a user
  I want to be able to choose a customer file to access

@wip
Scenario: User has access to multiple Customer Files
  Given the user has access to multiple Customer Files
  When the user logs-in to AccountRight Live
  Then the Customer Files page should be shown
  And all the Customer Files are shown

@wip
Scenario: User has access to one Customer File
  Given the user has access to one Customer File
  When the user logs-in to AccountRight Live
  Then the Customer Files page should be shown
  And the Customer File is shown
  And the Customer File login is shown

@wip
Scenario: User does not have access to a Customer File
  Given the user does not have access to any Customer File
  When the user logs-in to AccountRight Live
  Then the Customer Files page should be shown
  And a message should be displayed indicating no customer files are available to access

@wip
Scenario: Error is shown when an unexpected API error occurs
  Given the API is unable to return data due to an expected error
  When the user logs-in to AccountRight Live
  Then the Customer Files page should be shown
  And an error should be displayed indicating the application is unavailable
