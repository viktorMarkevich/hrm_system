Feature: Manage candidates
  In order to create candidates list
  As a manager
  I want to create and manage candidates

  Scenario: Create a valid candidate
    Given I have no candidates
    And I have logged in user
    And I am on the candidates list page
    When I click add candidate sign
    And I fill in candidate form
    And I press "Создать"
    Then new candidate should be created