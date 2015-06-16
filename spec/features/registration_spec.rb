require 'rails_helper'

describe 'the signup process', type: :feature do
  before :each do
    @user = build(:user)
    visit 'users/sign_up'
  end

  it 'sign_up me' do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
    end
    click_button 'Sign up'
    expect(page).to have_content 'logout'
  end

  it 'registration Email has already been taken' do
    @user = create(:user)
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
    end
    click_button 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end

  it "registration Email can't be blank" do
    within('#new_user') do
      fill_in 'Email', with: nil
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
    end
    click_button 'Sign up'
    expect(page).to have_content "Email can't be blank"
  end

  it "registration Password can't be blank" do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: nil
      fill_in 'Password confirmation', with: @user.password
    end
    click_button 'Sign up'
    expect(page).to have_content "Password can't be blank"
  end

  it "registration Email and Password can't be blank" do
    within('#new_user') do
      fill_in 'Email', with: nil
      fill_in 'Password', with: nil
      fill_in 'Password confirmation', with: nil
    end
    click_button 'Sign up'
    expect(page).to have_content '2 errors prohibited this user from being saved:'
  end

  it "registration Password confirmation doesn't match Password" do
    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', :with => nil
    end
    click_button 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end