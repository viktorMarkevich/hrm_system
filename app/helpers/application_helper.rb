module ApplicationHelper

  def active_class(controller, link_path = nil)
    if link_path
      current_page?(link_path) ? 'active current' : ''
    else
      params[:controller] == controller && params[:action] != 'new' ? 'active current' : ''
    end
  end

  def display_field_value_for(field)
    field.nil? || field.empty? ? 'Информация не добавлена' : field
  end

  def get_author_and_date(object)
    "#{full_name_for(object.owner)} #{object.created_at.strftime('%F')}"
  end

end