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
    fill_in 'candidate_birthday', with: '1989-12-09'
    fill_in 'candidate_salary', with: '450'
    fill_in 'candidate_education', with: 'Оксфорд, бакалавр'
    fill_in 'candidate_city_of_residence', with: 'Запорожье'
    fill_in 'candidate_desired_position', with: 'Программист'
    fill_in 'candidate_experience', with: '3 года'
    fill_in 'candidate_status', with: 'В процессе'
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