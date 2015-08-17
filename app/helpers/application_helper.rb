module ApplicationHelper

  def display_field_value_for(field)
    field.nil? || field.empty? ? 'Информация не добавлена' : field
  end

  def get_author_and_date(object)
    "#{full_name_for(object.owner)} #{object.created_at.strftime('%F')}"
  end

  def return_upcoming_events(event)
    "&nbsp; c #{link_to 'Ланистер', candidate_path('#')} на
     <div class= 'label label-info'>#{event.starts_at.strftime('%e %b %H:%M')}</div>
     на должность #{link_to 'Рубист', vacancy_path('#')}".html_safe
  end

  def return_status_label(sr)
    case sr.status
      when 'Найденные'
        'default'
      when 'Отобранные'
        'primary'
      when 'Собеседование'
        'success'
      when 'Утвержден'
        'info'
      when 'Не подходит'
        'warning'
      when 'Отказался'
        'danger'
    end
  end
end