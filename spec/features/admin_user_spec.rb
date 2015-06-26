require 'rails_helper'

RSpec.describe 'AdminUser', type: :feature do

  before :each do
    @admin_user = create(:admin_user)
    @user = create(:user)
    create(:region)
    sign_in_as(@admin_user, nil, 'admin')
  end

  scenario 'signin' do
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'logout' do
    click_link 'Logout'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'show AdminUsers' do
    click_link 'Admin Users'
    expect(page).to have_content @admin_user.email
  end

  scenario 'show Users' do
    click_link 'Users'
    expect(page).to have_content @user.email
  end

  scenario 'show AdminUser' do
    visit "admin/admin_users/#{@admin_user.id}"
    expect(page).to have_content 'Admin User Details'
  end

  scenario 'show User' do
    visit "admin/users/#{@user.id}"
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

  scenario 'update User' do
    test_user = create(:user)
    visit "admin/users/#{test_user.id}/edit"
    fill_in 'user_email', with: 'proba@ppp.ppp'
    click_button 'Update User'
    expect(page).to have_content 'User was successfully updated.'
  end

  scenario 'create AdminUser' do
    test_user = build(:admin_user)
    visit 'admin/admin_users/new'
    fill_in 'admin_user_email', with: test_user.email
    fill_in 'admin_user_password', with: test_user.password
    fill_in 'admin_user_password_confirmation', with: test_user.password
    click_button 'Create Admin user'
    expect(page).to have_content 'Admin user was successfully created.'
  end

  scenario 'create AdminUser not valid' do
    test_user = build(:admin_user)
    visit 'admin/admin_users/new'
    fill_in 'admin_user_email', with: 'rqwrqwr'
    fill_in 'admin_user_password', with: test_user.password
    fill_in 'admin_user_password_confirmation', with: test_user.password
    click_button 'Create Admin user'
    expect(page).to have_content 'is invalid'
  end

  scenario 'create User' do
    test_user = build(:user)
    visit 'admin/users/new'
    fill_in 'user_email', with: test_user.email
    fill_in 'user_first_name', with: test_user.first_name
    fill_in 'user_last_name', with: test_user.last_name
    fill_in 'user_post', with: test_user.post
    click_button 'Create User'
    expect(page).to have_content 'User was successfully created.'
  end

  scenario 'create User not valid' do
    test_user = build(:user)
    visit 'admin/users/new'
    fill_in 'user_email', with: test_user.email
    fill_in 'user_first_name', with: ''
    fill_in 'user_last_name', with: test_user.last_name
    fill_in 'user_post', with: test_user.post
    click_button 'Create User'
    expect(page).to have_content %q{can't be blank}
  end

  scenario 'create User Invite' do
    test_user = build(:user)
    visit 'admin/users/new_invitation'
    fill_in 'user_email', with: test_user.email
    fill_in 'user_first_name', with: ''
    fill_in 'user_last_name', with: test_user.last_name
    fill_in 'user_post', with: test_user.post
    click_button 'Send an Invitation'
    expect(page).to have_content %q{User has been successfully invited.}
  end

  scenario 'delete AdminUser' do
    pending
    test_user = create(:admin_user)
    visit "admin/admin_users/#{test_user.id}"
    click_link 'Delete Admin User'
    click_button('OK')
    expect(page).to have_content 'Admin user was successfully destroyed.'
  end

  scenario 'delete User' do
    pending
    visit "admin/users/#{@user.id}"
    click_link 'Delete User'
    page.evaluate_script('data-confirm')
    page.click('OK')
    expect(page).to have_content 'User was successfully destroyed.'
  end


end