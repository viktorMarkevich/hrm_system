module ApplicationHelper

  def active_class(controller, link_path = nil)
    if link_path
      current_page?(link_path) ? 'active current' : ''
    elsif params[:controller] == controller && params[:action] != 'new' ||
          params[:object_name] && params[:object_name] == controller
      'active current'
    end || ''
  end

  def display_field_value_for(field)
    field.nil? || field.empty? ? 'Информация не добавлена' : field
  end

end