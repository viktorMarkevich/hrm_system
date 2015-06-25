require 'rails_helper'

describe 'changing registration data', type: :feature do
  before(:each) do
    @user = create(:user)
    create(:region, name: 'Запорожье')
    create(:region, name: 'Киев')

    sign_in_as(@user)
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
    expect(page).to have_content('Your account has been updated successfully.')
    click_link 'Выйти'
  end
end