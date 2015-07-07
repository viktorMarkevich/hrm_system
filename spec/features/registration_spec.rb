require 'rails_helper'

describe 'changing registration data', type: :feature do
  let(:user) { create(:user) }

  before do
    create(:region, name: 'Запорожье')
    create(:region, name: 'Киев')

    sign_in_as(user, nil)
  end

  scenario 'edit user password' do
    visit root_path
    click_link user.email
    click_link 'хочу изменить свой пароль'

    within '#edit_user' do
      fill_in 'user_password', with: 'updated_password'
      fill_in 'user_password_confirmation', with: 'updated_password'
      fill_in 'user_current_password', with: user.password
    end
    click_button 'Изменить'
    expect(page).to have_content('Your account has been updated successfully.')
    click_link 'Выйти'
  end
end