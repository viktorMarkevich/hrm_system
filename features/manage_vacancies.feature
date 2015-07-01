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

  Scenario: Update vacancy
    Given I have valid vacancy
    And I have logged in user
    And I am on the vacancy edit page
    And I change region in edit form
    And I press "Обновить"
    Then I should see successfull message

  Scenario: Try crate vacancy with invalid salary format
    Given I have logged in user
    And I am on the new vacancy path
    When I fill form with invalid salary value
    And I press "Создать"
    Then I should see error message
