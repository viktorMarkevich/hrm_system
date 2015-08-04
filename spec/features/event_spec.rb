require 'rails_helper'

describe 'Managing events', type: :feature do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  before do
    event
    sign_in_as(user, nil)
  end

  scenario 'goes on new event page' do
    visit '/events/new'
    expect(page).to have_content 'Добавить новое событие'
    expect(page).to have_content 'Имя:'
    expect(page).to have_content 'Дата события:'
    expect(page).to have_content 'Описание:'
  end

  scenario 'create new event' do
    visit '/events/new'
    within '#new_event' do
      fill_in 'event_name', with: 'This is name'
      select "#{(Time.now + 1.month).strftime("%B")}", from: 'event_starts_at_2i'
      fill_in 'event_description', with: 'This is description'
      click_button 'Сохранить'
    end
    expect(page).to have_content 'Событие успешно создано.'
  end

  scenario 'edits event' do
    visit '/events'
    click_link 'Редактировать'
    expect(page).to have_content 'Редактировать событие'
  end

  scenario 'deletes event' do
    visit '/events'
    delete_link = find_link 'Удалить'
    expect(delete_link['data-confirm']).to eq 'Вы уверены?'
  end

  scenario 'goes to events#index page from events#edit page' do
    visit '/events'
    click_link 'Редактировать'
    click_link 'Назад'
    expect(page).to have_content 'Календарь'
  end

  scenario 'goes to stickers#show page' do
    visit '/events'
    click_link 'Просмотреть'
    expect(page).to have_content 'Начало события'
  end

  scenario 'goes to events#index page from events#show page' do
    visit '/events'
    click_link 'Просмотреть'
    click_link 'Назад'
    expect(page).to have_content 'Календарь'
  end

end