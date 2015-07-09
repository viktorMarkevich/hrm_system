module StickersHelper

  def performer_array
    User.all.map { |p| [full_name_for(p), p.id] }
  end

end