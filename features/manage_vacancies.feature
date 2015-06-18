Feature: Manage vacancies
  In order to create vacancies list
  As an manager
  I want to create and manage vacancies

  Scenario: Create valid vacancy
    Given I have no vacancies
    And I have logged in user
    And I am on the vacancies list page
    When I click add vacancy sign
    And I fill in vacancy form
    And I press "Создать"
    Then new vacancy should be created

  Scenario: Get to vacancy edit page
    Given I have valid vacancy
    And I have logged in user
    And I am on the vacancies list page
    When I click on the vacancy title
    And I click link "Редактировать"
    Then I should see vacancy edit page