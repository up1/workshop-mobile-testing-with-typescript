Feature: Product List

  @flow04
  Scenario Outline: As a user, I can goto the product list page and see the list of products

    Given I am on the product list page
    When I scroll down to the last of the product list page
    Then I tap on the last product in the list
    Then I should see a product detail page