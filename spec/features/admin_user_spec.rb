require 'rails_helper'

RSpec.describe 'AdminUser', type: :feature do
  let(:admin_user) { create(:admin_user) }
  let(:user) { create(:user) }

  before { sign_in_as(admin_user, nil, 'admin') }

  scenario 'sign in' do
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'logout' do
    click_link 'Logout'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'show AdminUsers' do
    click_link 'Admin Users'
    expect(page).to have_content admin_user.email
  end

  scenario 'show Users' do
    user
    click_link 'Users'
    expect(page).to have_content user.email
  end

  scenario 'show AdminUser' do
    visit "admin/admin_users/#{admin_user.id}"
    expect(page).to have_content 'Admin User Details'
  end

  scenario 'show User' do
    visit "admin/users/#{user.id}"
    expect(page).to have_content 'User Details'
  end

  scenario 'update AdminUser' do
    test_user = create(:admin_user)
    visit "admin/admin_users/#{test_user.id}/edit"
    fill_in 'admin_user_email', with: 'proba@ppp.ppp'
    fill_in 'admin_user_password', with: test_user.password
    fill_in 'admin_user_password_confirmation', with: test_user.password
    click_button 'Update Admin user'
    expect(page).to have_content 'Admin user was successfully updated.'
  end

  scenario 'update User email' do
    visit "admin/users/#{user.id}/edit"
    fill_in 'user_email', with: 'proba@ppp.ppp'
    select 'Директор', from: 'user_post'
    select 'Запорожье', from: 'user_region_id'
    click_button 'Update User'
    expect(page).to have_content 'Пользователь успешно обновлен.'
  end

  scenario 'update User region' do
    visit "admin/users/#{user.id}/edit"
    find('#user_region_id').find(:xpath, 'option[3]').select_option
    select 'Директор', from: 'user_post'
    click_button 'Update User'
    expect(page).to have_content 'Пользователь успешно обновлен.'
    expect(page).to have_content 'Донецк'
  end

  scenario 'create AdminUser' do
    new_admin_user = build(:admin_user)
    visit 'admin/admin_users/new'
    fill_in 'admin_user_email', with: new_admin_user.email
    fill_in 'admin_user_password', with: new_admin_user.password
    fill_in 'admin_user_password_confirmation', with: new_admin_user.password
    click_button 'Create Admin user'
    expect(page).to have_content 'Admin user was successfully created.'
  end

  scenario 'create AdminUser not valid' do
    visit 'admin/admin_users/new'
    fill_in 'admin_user_email', with: 'rqwrqwr'
    fill_in 'admin_user_password', with: admin_user.password
    fill_in 'admin_user_password_confirmation', with: admin_user.password
    click_button 'Create Admin user'
    expect(page).to have_content 'is invalid'
  end

  scenario 'create User' do
    visit 'admin/users/new'
    fill_in 'user_email', with: 'aaaa@aaa.aaa'
    fill_in 'user_first_name', with: user.first_name
    fill_in 'user_last_name', with: user.last_name
    select('Директор', from: 'user_post')
    select('Запорожье', from: 'region')
    click_button 'Send an Invitation'
    expect(page).to have_content 'User has been successfully invited.'
  end

  scenario 'create User not valid' do
    test_user = build(:user)
    visit 'admin/users/new'
    fill_in 'user_email', with: user.email
    fill_in 'user_first_name', with: test_user.first_name
    fill_in 'user_last_name', with: test_user.last_name
    select('HR Менеджер', from: 'user_post')
    select('Запорожье', from: 'region')
    click_button 'Send an Invitation'
    expect(page).to have_content 'Пользователь с таким email уже существует!'
  end

  scenario 'delete AdminUser' do
    test_user = create(:admin_user)
    visit "admin/admin_users/#{test_user.id}"
    click_link 'Delete Admin User'
    expect(page).to have_content 'Admin user was successfully destroyed.'
  end

  scenario 'delete User'do
    visit "admin/users/#{user.id}"
    click_link 'Delete User'
    expect(page).to have_content 'User was successfully destroyed.'
  end
end