require 'spec_helper'

describe "the sign_out process", :type => :feature do

  before :each do
    @user = create(:user)
    login(@user)
  end

  def login(user)
    visit 'users/sign_in'
    within("#new_user") do
      fill_in 'Email', :with => user.email
      fill_in 'Password', :with => user.password
    end
    click_button 'Log in'
  end

  it "sign_out me" do
    click_link 'logout'
    expect(page).to have_content 'sign_in'
  end

  after :each do
   User.destroy_all
  end

end