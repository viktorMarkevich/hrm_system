require 'rails_helper'

describe 'user process', type: :feature do

  before :each do
    @user = create(:user)
    login(@user)
  end

  def login(user)
    visit 'users/login'
    within('#new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Log in'
  end

  scenario %q{page has user's full name} do
    click_link @user.email
    expect(page).to have_content("#{@user.first_name} #{@user.last_name}")
  end

  scenario 'update user profile' do
    click_link @user.email
    click_link 'Редактировать'
    within('.edit_user') do
      fill_in 'user_email', with: 'ccc@ccc.ccc'
    end
    click_button 'Обновить'
    expect(page).to have_content 'ccc@ccc.ccc'
  end

  scenario 'edit page has full user name' do
    click_link @user.email
    click_link 'Редактировать'
    expect(page).to have_content("#{@user.first_name} #{@user.last_name}")
  end

  scenario 'edit password page has full user page' do
    click_link @user.email
    click_link 'хочу изменить свой пароль'
    expect(page).to have_content("#{@user.first_name} #{@user.last_name}")
  end

  scenario 'update user profile with wrong params' do
    click_link @user.email
    click_link 'Редактировать'
    within('.edit_user') do
      fill_in 'user_email', with: ''
    end
    click_button 'Обновить'
    expect(page).to have_content 'Обновить'
  end

end