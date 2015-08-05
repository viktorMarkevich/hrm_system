# coding: utf-8

require 'rails_helper'

describe 'Managing companies', type: :feature do
  let(:user) { create(:user) }
  let(:company) { create(:company) }

  before do
    company
    sign_in_as(user, nil)
  end

  scenario 'creates new company' do
    visit new_company_path

    within '#new_company' do
      fill_in 'company_name', with: 'Company 777'
      fill_in 'company_url', with: 'http://www.facebook.com/'
      select 'Запорожье', from: 'region'
      fill_in 'company_description', with: 'Descriptive text'
      click_button 'Создать'
    end
    expect(page).to have_content 'Компания была успешно создана.'
  end

  scenario 'edit company' do
    visit companies_path

    click_link company.name
    click_link 'Редактировать'
    expect(page).to have_content 'Изменить данные компании'
  end

  scenario 'goes back from companies#index page to companies#show page' do
    visit companies_path

    click_link company.name
    click_link 'Назад'
    expect(page).to have_content 'Компании'
  end

  scenario 'goes back from companies#edit page to companies#show page' do
    visit companies_path

    click_link company.name
    click_link 'Редактировать'
    click_link 'Назад'
    expect(page).to have_content 'Редактировать'
  end

  scenario 'update company' do
    visit companies_path

    click_link company.name
    click_link 'Редактировать'
    within "#edit_company_#{company.id}" do
      fill_in 'company_name', with: 'Company 777'
      fill_in 'company_url', with: 'http://www.facebook.com/'
      click_button 'Обновить'
    end
    expect(page).to have_content('Компания успешно обновлена.')
  end
end