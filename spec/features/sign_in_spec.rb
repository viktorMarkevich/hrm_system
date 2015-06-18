require 'rails_helper'

describe 'the signin process', type: :feature do
  before :each do
    @user = create(:user)
    visit 'users/sign_in'
  end

  scenario 'sign_in me' do
    sign_in_user
    expect(page).to have_content 'Выйти'
  end

  scenario 'visit stickers#index page when signed in' do
    sticker = create(:sticker, title: 'Test sticker title')
    sign_in_user
    expect(page).to have_content(sticker.title)
  end

  scenario 'sign_in with wrong Email' do
    within('#new_user') do
      fill_in 'Email', with: 'aaa@aaa.aaa'
      fill_in 'Password', with: @user.password
    end
    click_button 'Log in'
    expect(page).to have_content 'Войти'
  end

  scenario 'sign_in with wrong Password' do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'aaaaaaaa'
    end
    click_button 'Log in'
    expect(page).to have_content 'Войти'
  end

  scenario 'sign_in with wrong Password and Email' do
    within('#new_user') do
      fill_in 'Email', with: 'aaa@aaa.aaa'
      fill_in 'Password', with: 'aaaaaaaa'
    end
    click_button 'Log in'
    expect(page).to have_content 'Войти'
  end

  def sign_in_user
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
    end
    click_button 'Log in'
  end
end