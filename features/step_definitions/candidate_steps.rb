Given(/^I have no candidates$/) do
  expect(Candidate.count).to eq(0)
end

Given(/^I am on the candidates list page$/) do
  visit candidates_path
end

When(/^I click add candidate sign$/) do
  find('#add-candidate').click
end

When(/^I fill in candidate form$/) do
  within('#new_candidate') do
    fill_in 'candidate_name', with: 'Сергей Петров'
    fill_in 'candidate_birthday', with: '12-09-1989'
    fill_in 'candidate_salary', with: '450'
    fill_in 'candidate_education', with: 'Оксфорд, бакалавр'
    fill_in 'candidate_city_of_residence', with: 'Запорожье'
    fill_in 'candidate_desired_position', with: 'должность1'
    fill_in 'candidate_experience', with: '3 года'
    select('Пассивен', from: 'candidate_status')
    check('Готов к переезду')
    fill_in 'candidate_email', with: 'spetrov@mail.com'
    fill_in 'candidate_phone', with: '+38-050-000-0001'
    fill_in 'candidate_skype', with: 'spetrov'
    fill_in 'candidate_home_page', with: 'http://www.spetrov.me'
    fill_in 'candidate_linkedin', with: 'https://ua.linkedin.com/pub/test-user/9a/29/644'
    fill_in 'candidate_facebook', with: 'http://www.facebook.com/test.user'
    fill_in 'candidate_vkontakte', with: 'http://vk.com/test_man'
    fill_in 'candidate_google_plus', with: 'https://plus.google.com/u/0/109854654'
  end
end

Then(/^new candidate should be created$/) do
  expect(Candidate.count).to eq(1)
end

Given(/^I am on the new candidate page$/) do
  visit new_candidate_path
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |input_id, text|
  fill_in input_id, with: text
end

When(/^I change candidate_status in edit form$/) do
  select('В работе', from: 'candidate_status')
end

When(/^I change candidate_desired_position in edit form$/) do
  fill_in 'candidate_desired_position', with: 'должность1'
end

Then(/^I should see errors like "(.*?)" and "(.*?)"$/) do |error1, error2|
  expect(page).to have_content(error1)
  expect(page).to have_content(error2)
end

Then(/^I should see error like "(.*?)"$/) do |error|
  expect(page).to have_content(error)
end

When(/^I fill in candidate required fields$/) do
  fill_in 'candidate_name', with: 'Test User'
  select('В работе', from: 'candidate_status')
  fill_in 'candidate_desired_position', with: 'должность1'
  fill_in 'candidate_phone', with: '123456'
end

