# coding: utf-8

require 'rails_helper'

describe 'Managing companies', type: :feature do
  before(:each) do
    @user = create(:user)
    region = create(:region, name: 'Запорожье')
    @company = create(:company, name: 'TruedCo', region_id: region.id)

    sign_in @user
  end

  scenario 'creates new company' do

    visit new_company_path
    within '#new_company' do
      fill_in 'company_name', with: 'Company 777'
      fill_in 'company_url', with: 'facebook 777'
      select 'Запорожье', from: 'company_region_id'
      click_button 'Создать'
    end
    expect(page).to have_content 'Компания была успешно создана.'
  end

  scenario 'edit company' do
    visit companies_path
    click_link @company.name
    click_link 'Редактировать'
    within('.edit_company') do
      fill_in('company_name', with: 'Updated name')
    end
    click_button 'Обновить'
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