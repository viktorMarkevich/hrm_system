# coding: utf-8

require 'rails_helper'

describe 'Managing companies', type: :feature do
  before do
    @user = create(:user)
    @company = create(:company)
    sign_in @user
    visit '/companies'
  end

  scenario 'goes on new company page' do
    click_link 'Компании'
    expect(page).to have_content @company.name
  end

  scenario 'creates new company' do
    visit '/companies/new'
    within '#new_company' do
      fill_in 'company_name', with: 'Company 777'
      fill_in 'company_url', with: 'http://www.facebook.com/'
      click_button 'Создать'
    end
    expect(page).to have_content 'Компания была успешно создана.'
  end

  scenario 'goes to stickers#edit page' do
    click_link @company.name
    click_link 'Редактировать'
    expect(page).to have_content 'Изменить данные компании'
  end

  scenario 'goes back from companies#index page to companies#show page' do
    click_link @company.name
    click_link 'Назад'
    expect(page).to have_content 'Компании'
  end

  scenario 'goes back from companies#edit page to companies#show page' do
    click_link @company.name
    click_link 'Редактировать'
    click_link 'Назад'
    expect(page).to have_content 'Редактировать'
  end

  scenario 'update company' do
    click_link @company.name
    click_link 'Редактировать'
    within "#edit_company_#{@company.id}" do
      fill_in 'company_name', with: 'Company 777'
      fill_in 'company_url', with: 'http://www.facebook.com/'
      click_button 'Обновить'
    end
    expect(page).to have_content 'Компания успешно обновлена.'
  end

  def sign_in(user)
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
  end
end