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

  Scenario: Hide salary input when last pay plan is chosen
    Given I have logged in user
    And I am on the new vacancy path
    When I fill form with salary_format as "По договоренности"
    Then salary field should disappear

  Scenario: Show candidates with status "Найденные" by default
    Given I have logged in user
    And I have valid vacancy
    When I am on the vacancy page
    Then I should see candidates with default status

  Scenario: Show available candidates for vacancy
    Given I have logged in user
    And I have valid vacancy
    And I have candidates for vacancy
    When I am on the vacancy page
    And I click link "Добавить кандидатов к этой вакансии"
    Then I should see available candidates for vacancy

  Scenario: Mark candidates as found for vacancy
    Given I have logged in user
    And I have valid vacancy
    And I have candidates for vacancy
    When I am on the vacancy page
    And I select candidate for vacancy
    Then item should be added to founded candidates