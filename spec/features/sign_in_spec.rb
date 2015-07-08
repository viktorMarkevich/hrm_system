require 'rails_helper'

describe 'the sign_in process', type: :feature do
  let(:user) { create(:user) }

  scenario 'visit stickers#index page when signed in' do
    sign_in_as(user, nil)
    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'sign_in with wrong Email' do
    visit 'users/login'

    within('#new_user') do
      fill_in 'Email', with: 'aaa@aaa.aaa'
      fill_in 'Password', with: ''
    end
    click_button 'Log in'
    expect(page).to have_content 'Log in'
  end
end