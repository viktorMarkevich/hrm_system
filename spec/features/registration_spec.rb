require 'rails_helper'

describe 'changing registration data', type: :feature do
  before(:each) do
    @user = create(:user)
    create(:region, name: 'Запорожье')
    create(:region, name: 'Киев')

    sign_in_with(@user.email, @user.password)
  end

  scenario 'edit user password' do
    visit root_path

    within '.navbar-right' do
      click_link @user.email
    end
    within '#head_user_profile' do
      click_link 'хочу изменить свой пароль'
    end
    within '#edit_user' do
      fill_in 'user_password', with: 'updated_password'
      fill_in 'user_password_confirmation', with: 'updated_password'
      fill_in 'user_current_password', with: @user.password
    end
    click_button 'Update'

    # sign out
    click_link 'Выйти'

    # trying to login with new password
    visit new_user_session_path
    sign_in_with(@user.email, 'updated_password')
    expect(page).to have_content('Signed in successfully.')
  end

  def sign_in_with(email, password)
    visit new_user_session_path

    within('#new_user') do
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
    end
    click_button 'Log in'
  end
end