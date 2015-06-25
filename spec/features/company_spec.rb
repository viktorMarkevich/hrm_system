# coding: utf-8

require 'rails_helper'

describe 'Managing companies', type: :feature do
  before(:each) do
    @user = create(:user)
    region = create(:region, name: 'Запорожье')
    @company = create(:company, name: 'TruedCo', region_id: region.id)

    sign_in @user
  end

  scenario 'should have "active current" class on company index page' do
    visit companies_path
    expect(page).to have_css('a.active.current', text: 'Компании')
    expect(page).to_not have_css('a.active.current', text: 'Вакансии')
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
    click_link @company.name
    click_link 'Редактировать'
    expect(page).to have_content 'Изменить данные компании'
  end

  scenario 'goes back from companies#index page to companies#show page' do
    visit companies_path
    click_link @company.name
    click_link 'Назад'
    expect(page).to have_content 'Компании'
  end

  scenario 'goes back from companies#edit page to companies#show page' do
    visit companies_path
    click_link @company.name
    click_link 'Редактировать'
    click_link 'Назад'
    expect(page).to have_content 'Редактировать'
  end

  scenario 'update company' do
    visit companies_path
    click_link @company.name
    click_link 'Редактировать'
    within "#edit_company_#{@company.id}" do
      fill_in 'company_name', with: 'Company 777'
      fill_in 'company_url', with: 'http://www.facebook.com/'
      click_button 'Обновить'
    end
    expect(page).to have_content('Компания успешно обновлена.')
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