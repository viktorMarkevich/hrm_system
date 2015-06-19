Feature: Manage vacancies
  In order to create vacancies list
  As a manager
  I want to create and manage vacancies

  Scenario: Create valid vacancy
    Given I have no vacancies
    And I have logged in user
    And I am on the vacancies list page
    When I click add vacancy sign
    And I fill in vacancy form
    And I press "Создать"
    Then new vacancy should be created
