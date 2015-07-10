module StickersHelper

  def selection_status
    current_user.is_director? ? Sticker::STATUS_D : Sticker::STATUS_M
  end

end