module UsersHelper
  def user_fullname
    "#{@user.first_name} #{@user.last_name}"
  end
end