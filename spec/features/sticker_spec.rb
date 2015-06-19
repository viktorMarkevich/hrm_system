# coding: utf-8

require 'rails_helper'

describe 'Managing stickers', type: :feature do
  before do
    @user = create(:user, email: 'test_user@mail.com')
    @sticker = create(:sticker)

    sign_in @user
  end

  scenario 'goes on new sticker page' do
    visit '/stickers/new'
    click_button 'Создать'
    click_link 'Назад'
    expect(page).to have_content 'Добавить новый стикер'
  end

  scenario 'creates new sticker' do
    visit '/stickers/new'
    within '#new_sticker' do
      fill_in 'sticker_title', with: 'New sticker'
      fill_in 'sticker_description', with: 'This is description'
      click_button 'Создать'
    end
    expect(page).to have_content 'Стикер был успешно создан.'
  end

  scenario 'goes to stickers#index page from stickers#new page' do
    pending
      visit '/stickers'
      click_link 'Редактировать'
      click_link 'Назад'
      expect(page).to have_content @sticker.title

  end

  scenario 'goes to stickers#edit page' do
    pending
      visit '/stickers'
      click_link 'Редактировать'
      expect(page).to have_content 'Редактировать стикер'

  end

  scenario 'goes back from stickers#edit page to stickers#index page' do
    pending
      visit '/stickers'
      click_link 'Редактировать'
      click_link 'Назад'
      expect(page).to have_content @sticker.title

  end

  scenario 'deletes sticker' do
    pending
      visit '/stickers'
      click_link 'Удалить'
      expect(page).to_not have_content @sticker.title
  end

  def sign_in(user)
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
  end
end