require 'rails_helper'

describe 'the signup process', type: :feature do
  before :each do
    @user = build(:user)
    visit 'users/sign_up'
  end

  scenario 'sign_up me' do
    sign_up_user
    expect(page).to have_content 'logout'
  end

  scenario 'visit stickers#index page when signed up' do
    sticker = create(:sticker, title: 'Test sticker title')
    sign_up_user
    expect(page).to have_content(sticker.title)
  end

  scenario 'registration Email has already been taken' do
    @user = create(:user)
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
    end
    click_button 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end

  scenario %q{registration Email can't be blank} do
    within('#new_user') do
      fill_in 'Email', with: nil
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
    end
    click_button 'Sign up'
    expect(page).to have_content %q{Email can't be blank}
  end

  scenario %q{registration Password can't be blank} do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: nil
      fill_in 'Password confirmation', with: @user.password
    end
    click_button 'Sign up'
    expect(page).to have_content %q{Password can't be blank}
  end

  scenario %q{registration Post can't be blank} do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
      fill_in 'user_post', with: nil
    end
    click_button 'Sign up'
    expect(page).to have_content "Post can't be blank"
  end

  scenario %q{registration First Name can't be blank} do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
      fill_in 'user_first_name', with: nil
    end
    click_button 'Sign up'
    expect(page).to have_content "First name can't be blank"
  end

  scenario %q{registration Last Name can't be blank} do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
      fill_in 'user_last_name', with: nil
    end
    click_button 'Sign up'
    expect(page).to have_content "Last name can't be blank"
  end

  scenario %q{registration Password confirmation doesn't match Password} do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: nil
    end
    click_button 'Sign up'
    expect(page).to have_content %q{Password confirmation doesn't match Password}
  end

  def sign_up_user
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'user_first_name', with: @user.first_name
      fill_in 'user_last_name', with: @user.last_name
      fill_in 'user_post', with: @user.post
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
    end
    click_button 'Sign up'
  end
end