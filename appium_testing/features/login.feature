Feature: Login flow

  Scenario Outline: As a user, I can log into the secure area

    Given I am on the login page
    When I login with <username> and <password>
    Then I should see a profile page with <fullname> and <email>

    Examples:
      | username | password | fullname | email |
      | user123 | pass123 | John Doe  | john.doe@example.com  |