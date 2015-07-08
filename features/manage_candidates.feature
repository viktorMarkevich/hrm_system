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

  Scenario: Check errors when only name is filled
    Given I have logged in user
    And I am on the new candidate page
    When I fill in "candidate_name" with "Test User"
    And I press "Создать"
    Then new candidate should be created

  Scenario: Check errors when only status is filled
    Given I have logged in user
    And I am on the new candidate page
    And I change candidate_status in edit form
    And I press "Создать"
    Then I should see error like "Name can't be blank"

  Scenario: Check errors when only position is filled
    Given I have logged in user
    And I am on the new candidate page
    And I change candidate_desired_position in edit form
    And I press "Создать"
    Then I should see error like "Name can't be blank"

  Scenario: Check error when input incorrect phone
    Given I have logged in user
    And I am on the new candidate page
    When I fill in candidate required fields
    And I fill in "candidate_phone" with "123456"
    And I press "Создать"
    Then I should see error like "Phone wrong format"

  Scenario: Check error when input incorrect linkedin url
    Given I have logged in user
    And I am on the new candidate page
    When I fill in candidate required fields
    And I fill in "candidate_linkedin" with "wrong_url"
    And I press "Создать"
    Then I should see error like "Linkedin wrong format"

  Scenario: Check error when input incorrect facebook url
    Given I have logged in user
    And I am on the new candidate page
    When I fill in candidate required fields
    And I fill in "candidate_facebook" with "wrong_url"
    And I press "Создать"
    Then I should see error like "Facebook wrong format"

  Scenario: Check error when input incorrect vkontakte url
    Given I have logged in user
    And I am on the new candidate page
    When I fill in candidate required fields
    And I fill in "candidate_vkontakte" with "wrong_url"
    And I press "Создать"
    Then I should see error like "Vkontakte wrong format"

  Scenario: Check error when input incorrect google plus url
    Given I have logged in user
    And I am on the new candidate page
    When I fill in candidate required fields
    And I fill in "candidate_google_plus" with "wrong_url"
    And I press "Создать"
    Then I should see error like "Google plus wrong format"