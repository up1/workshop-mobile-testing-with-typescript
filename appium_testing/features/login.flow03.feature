Feature: Use miniApp in webview

  @flow03
  Scenario Outline: As a user, I can log into the miniApp and use first miniApp

    Given I am on the login page to use miniApp
    When I login with <username> and <password>
    Then I should see a miniApp list page
    When I tap on the first miniApp
    Then I should see the miniApp webview page
    When I send a <message> from miniApp to Flutter
    Then I should see a snackbar with the message from the miniApp

    Examples:
      | username | password | message |
      | user123  | pass123 | Hello from miniApp |