Feature: Authenticated AccountRight Live Access
  In order to secure access to data
  As a user
  I want access to AccountRight Live to be authenticated

  Scenario: Login with valid credentials navigates user to Customer File page
    Given the user visits the AccountRight Live Login page
    And the user enters valid login credentials
    When the user attempts to login
    Then the Customer Files page should be shown
