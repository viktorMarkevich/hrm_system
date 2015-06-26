module CapybaraHelpers

  def sign_in_as(user, password = nil)
    visit 'users/login'
    within('#new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password || user.password
    end
    click_button 'Log in'
  end

  def sign_out_as_user
    click_link 'Выйти'
  end

  def full_name_for(user)
    "#{user.first_name} #{user.last_name}"
  end

end
