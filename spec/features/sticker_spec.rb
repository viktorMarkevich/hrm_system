# coding: utf-8

require 'rails_helper'

describe 'Managing stickers with Директор', type: :feature do
  let(:user) { create(:user) }
  let(:sticker) { create(:sticker) }

  before do
    sticker
    sign_in_as(user, nil)
  end

  scenario 'goes on new sticker page' do
    visit '/stickers/new'
    expect(page).to have_content 'Добавить новый стикер'
    expect(page).to have_content 'Описание'
    expect(page).to have_content 'Назначить на'
  end

  scenario 'creates new sticker' do
    visit '/stickers/new'
    within '#new_sticker' do
      fill_in 'sticker_description', with: 'This is description'
      click_button 'Создать'
    end
    expect(page).to have_content 'Стикер был успешно создан.'
  end

  scenario 'goes to stickers#index page from stickers#edit page' do
    visit '/stickers'
    find('.glyph_edit_link').click
    click_link 'Назад'
    expect(page).to have_content sticker.description
  end

  scenario 'goes to stickers#edit page' do
    visit '/stickers'
    find('.glyph_edit_link').click
    expect(page).to have_content 'Редактировать стикер'
  end

  scenario 'edits sticker' do
    visit '/stickers'
    find('.glyph_edit_link').click
    within('.edit_sticker') do
      fill_in 'sticker_description', with: 'updated description'
    end
    click_button 'Обновить'
    expect(page).to have_content('Стикер был успешно обновлен.')
  end

  scenario 'deletes sticker' do
    visit '/stickers'
    find('.glyph_destroy_link').click
    expect(page).to_not have_content sticker.description
  end
end

describe 'Managing stickers with HR Менджер', type: :feature do
  let(:user) { create(:user, post: 'HR Менджер') }
  let(:sticker) { create(:sticker) }

  before do
    sticker
    sign_in_as(user, nil)
  end

  scenario 'Error goes on new' do
    visit '/stickers/new'
    expect(page).to have_content 'У Вас недостаточно прав!'
  end

end