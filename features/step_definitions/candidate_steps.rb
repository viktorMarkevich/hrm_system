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
    select('1989-12-09', from: 'День рождения')
    fill_in 'candidate_salary', with: '450'
    fill_in 'candidate_education', with: 'Оксфорд, бакалавр'
    fill_in 'candidate_city_of_residence', with: 'Запорожье'
    select('Программист', from: 'На должность')
    fill_in 'candidate_experience', with: '3 года'
    fill_in 'candidate_status', with: 'В процессе'
    check('Готов к переезду')
    fill_in 'candidate_email', with: 'spetrov@mail.com'
    fill_in 'candidate_phone', with: '+380500000001'
    fill_in 'candidate_skype', with: 'spetrov'
    fill_in 'candidate_home_page', with: 'http://www.spetrov.me'
    fill_in 'candidate_linkedin', with: 'spetrov.linkedin'
    fill_in 'candidate_facebook', with: 'spetrov.facebook'
    fill_in 'candidate_vkontakte', with: 'spetrov.vkontakte'
    fill_in 'candidate_google_plus', with: 'spetrov.google_plus'
  end
end

Then(/^new candidate should be created$/) do
  expect(Candidate.count).to eq(1)
end