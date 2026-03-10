Feature: Use miniApp

  @flow02
  Scenario Outline: As a user, I can log into the miniApp and see the list of miniApps

    Given I am on the login page to use miniApp
    When I login with <username> and <password>
    Then I should see a miniApp list page

    Examples:
      | username | password | 
      | user123  | pass123 | 