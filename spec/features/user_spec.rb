require 'rails_helper'

describe 'user process', type: :feature do

  before :each do
    @user = create(:user)
    sign_in_as(@user)
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