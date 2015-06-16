require 'rails_helper'

describe 'the signin process', type: :feature do
  before :each do
    @user = create(:user)
    visit 'users/sign_in'
  end

  it 'sign_in me' do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
    end
    click_button 'Log in'
    expect(page).to have_content 'logout'
  end

  it 'sign_in with wrong Email' do
    within('#new_user') do
      fill_in 'Email', with: 'aaa@aaa.aaa'
      fill_in 'Password', with: @user.password
    end
    click_button 'Log in'
    expect(page).to have_content 'sign_in'
  end

  it 'sign_in with wrong Password' do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'aaaaaaaa'
    end
    click_button 'Log in'
    expect(page).to have_content 'sign_in'
  end

  it 'sign_in with wrong Password and Email' do
    within('#new_user') do
      fill_in 'Email', with: 'aaa@aaa.aaa'
      fill_in 'Password', with: 'aaaaaaaa'
    end
    click_button 'Log in'
    expect(page).to have_content 'sign_in'
  end
end