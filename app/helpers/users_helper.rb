module UsersHelper

  def full_name_for(user)
    user.present? ? "#{user.first_name} #{user.last_name}" : 'Информация не добавлена'
  end

end