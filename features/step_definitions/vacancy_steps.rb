# coding: utf-8

Given(/^I have logged in user$/) do
  User.create(
      email: 'user@mail.com',
      password: 'password',
      post: 'tester',
      first_name: 'Vasya',
      last_name: 'Pro'
  )

  visit new_user_session_path
  within('#new_user') do
    fill_in 'Email', with: 'user@mail.com'
    fill_in 'Password', with: 'password'
  end
  click_button 'Log in'
end

Given(/^I have no vacancies$/) do
  expect(Vacancy.count).to eq(0)
end

Given(/^I am on the vacancies list page$/) do
  visit vacancies_path
end

When(/^I click add vacancy sign$/) do
  find('#add-vacancy').click
end

When(/^I fill in vacancy form$/) do
  within('#new_vacancy') do
    fill_in('vacancy_name', with: 'Тестер')
    fill_in('vacancy_salary', with: '450')
    choose('vacancy_salary_format_usd')
    fill_in('vacancy_region', with: 'Запорожье')
    select('status1', from: 'Статус')
    fill_in('vacancy_languages', with: 'Английский, Русский')
    fill_in('vacancy_requirements', with: 'Ответственный')
  end
end

When(/^I press "(.*?)"$/) do |button|
  click_button button
end

When(/^I click link "(.*?)"$/) do |link|
  click_link link
end


Then(/^new vacancy should be created$/) do
  expect(Vacancy.count).to eq(1)
end

Given(/^I have valid vacancy$/) do
  Vacancy.create(
      name: 'Тестер',
      region: 'Запорожье',
      salary: '300-350',
      salary_format: 'USD',
      languages: 'Английский',
      status: 'В процессе',
      requirements: 'ОТветственный'
  )
end

When(/^I click on the vacancy title$/) do
  click_link 'vacancy-name'
end

Then(/^I should see vacancy edit page$/) do
  expect(page).to have_content('Отредактировать вакансию')
end
