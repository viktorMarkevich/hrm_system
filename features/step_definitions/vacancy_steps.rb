# coding: utf-8

Given(/^I have logged in user$/) do
  User.create(
      email: 'user@mail.com',
      password: 'password',
      first_name: 'Vasya',
      region_id: 1,
      last_name: 'Pro',
      post: 'tester'
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
  Region.create(name: 'Запорожье')
  find('#add-vacancy').click
end

When(/^I fill in vacancy form$/) do
  within('#new_vacancy') do
    fill_in('vacancy_name', with: 'Тестер')
    fill_in('vacancy_salary', with: '450')
    choose('vacancy_salary_format_usd')
    select('Запорожье', from: 'vacancy_region_id')
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
  @vacancy = Vacancy.create(
      name: 'Программист руби',
      salary: '500',
      salary_format: 'USD',
      status: 'В процессе',
      region_id: 1
  )
end

Given(/^I am on the vacancy edit page$/) do
  Region.create(name: 'Киев')
  visit "/vacancies/#{@vacancy.id}/edit"
end

When(/^I change region in edit form$/) do
  within('.edit_vacancy') do
    select('Киев', from: 'vacancy_region_id')
  end
end

Then(/^I should see successfull message$/) do
  expect(page).to have_content('Вакансия успешно обновлена.')
end
