module ApplicationHelper

  def active_class(controller, link_path = nil)
    if link_path
      current_page?(link_path) ? 'active current' : ''
    else
      params[:controller] == controller && params[:action] != 'new' ? 'active current' : ''
    end
  end

end
