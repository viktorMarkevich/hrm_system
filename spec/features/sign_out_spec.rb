require 'rails_helper'

describe 'the sign_out process', type: :feature do
  let(:user) { create(:user) }

  before { sign_in_as(user, 'user', nil) }

  scenario 'sign_out me' do
    click_link 'Выйти'
    expect(page).to have_content 'Log in'
  end
end