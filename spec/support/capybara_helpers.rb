module CapybaraHelpers

  def sign_in_as(user, password = nil, path_for = 'users')
    visit "#{path_for}/login"

    fill_in 'Email', with: user.email
    fill_in 'Password', with: password || user.password

    login_btn = path_for == 'users' ? 'Log in' : 'Login'

    click_button login_btn
  end

  def sign_out_as_user
    click_link 'Выйти'
  end

  def full_name_for(user)
    "#{user.first_name} #{user.last_name}"
  end

end
