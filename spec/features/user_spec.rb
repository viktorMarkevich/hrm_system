require 'rails_helper'

describe 'user process', type: :feature do
  let(:user) { create(:user) }

  before { sign_in_as(user, nil) }

  scenario %q{ page has user's full name } do
    click_link user.email
    expect(page).to have_content("#{full_name_for(user)}")
  end

  scenario 'edit page has full user name' do
    click_link user.email
    click_link 'Редактировать'
    expect(page).to have_content("#{full_name_for(user)}")
  end

  scenario 'visit managers list page' do
    click_link 'Менеджеры'
    expect(page).to have_content('Созданных вакансий')
  end
end
RSpec.feature 'Sign In', :type => :feature do

  describe "correct error message w/ wrong password" do
    before :each do
      @user = create(:user)
      @user.confirmed_at

      visit new_user_session_path
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: "wrongpassword"
      click_button "Log in"
    end

    it "tells user on page 'Invalid Email or password'" do
      expect(page).to have_text("Invalid Email or password.")
    end
  end

end