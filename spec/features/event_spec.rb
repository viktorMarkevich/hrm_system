require 'rails_helper'

describe 'Managing events', type: :feature do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:staff_relation) { create(:staff_relation) }

  before do
    event
    staff_relation
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
      select "#{(Time.now + 1.month).strftime('%B')}", from: 'event_starts_at_2i'
      option = first('#staff_relation').text
      select option, from: 'staff_relation'
      fill_in 'event_description', with: 'This is description'
      click_button 'Сохранить'
    end
    expect(page).to have_content 'Событие успешно создано.'
  end

  scenario 'event modal check' do
    visit '/events'
    expect(page).to have_css('#myModalLabel')
    expect(page).not_to have_content("#{event.starts_at}")
  end

end