module StickersHelper

  def selection_status
    current_user.is_director? ? Sticker::DIRECTOR_STATUS : Sticker::MANAGER_STATUS
  end

end