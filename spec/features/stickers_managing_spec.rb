# coding: utf-8

require 'rails_helper'

describe 'Managing stickers', type: :feature do
  before do
    @sticker = create(:sticker)
  end

  it 'goes on new sticker page' do
    visit '/stickers'
    click_link 'Добавить стикер'
    expect(page).to have_content 'Добавить новый стикер'
  end

  it 'creates new sticker' do
    visit '/stickers/new'
    within '#new_sticker' do
      fill_in 'sticker_title', with: 'New sticker'
      fill_in 'sticker_description', with: 'This is description'
      click_button 'Создать'
    end
    expect(page).to have_content 'Стикер был успешно создан.'
  end

  it 'goes to stickers#index page from stickers#new page' do
    visit '/stickers'
    click_link 'Добавить стикер'
    click_link 'Назад'
    expect(page).to have_content 'Добавить стикер'
  end

  it 'goes to stickers#show page' do
    visit '/stickers'
    click_link @sticker.title
    expect(page).to have_content 'Информация о стикере'
  end

  it 'goes back from stickers#show page to stickers#index page' do
    visit '/stickers'
    click_link @sticker.title
    click_link 'Назад'
    expect(page).to have_content 'Добавить стикер'
  end

  it 'goes to stickers#edit page' do
    visit '/stickers'
    click_link 'Редактировать'
    expect(page).to have_content 'Редактировать стикер'
  end

  it 'goes back from stickers#edit page to stickers#index page' do
    visit '/stickers'
    click_link 'Редактировать'
    click_link 'Назад'
    expect(page).to have_content('Добавить стикер')
  end

  it 'deletes sticker' do
    visit '/stickers'
    click_link 'Удалить'
    expect(page).to_not have_content @sticker.title
  end
end