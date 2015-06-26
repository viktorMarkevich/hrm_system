require 'rails_helper'

describe 'the sign_out process', type: :feature do

  before do
    @user = create(:user)
    sign_in_as(@user, nil)
  end

  scenario 'sign_out me' do
    click_link 'Выйти'
    expect(page).to have_content 'Log in'
  end
end