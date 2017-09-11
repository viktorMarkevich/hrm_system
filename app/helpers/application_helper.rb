module ApplicationHelper

  def display_field_value_for(field)
    field.nil? || field.empty? ? 'Информация не добавлена' : field
  end

  def get_author_and_date(object)
    "#{full_name_for(object.owner)} #{object.created_at.strftime('%F')}"
  end

  def get_date_when_added(object)
    object.created_at.strftime('%F')
  end

  def get_author_vacancy(object)
    "#{full_name_for(object.owner)}"
  end

  def return_upcoming_events(event)   # ?????????????/
    "&nbsp; c #{link_to 'Ланистер', candidate_path('#')} на
     <div class= 'label label-info'>#{event.will_begin_at.strftime('%e %b %H:%M')}</div>
     на должность #{link_to 'Рубист', vacancy_path('#')}".html_safe
  end

  def return_status_label(sr)
    case sr.status
      when 'Найденные'
        'default'
      when 'Отобранные'
        'primary'
      when 'Собеседование'
        'info'
      when 'Утвержден'
        'success'
      when 'Не подходит'
        'warning'
      when 'Отказался'
        'danger'
    end
  end

  def bootstrap_class_for flash_type
    case flash_type.to_sym
      when :success
        'alert-success'
      when :error
        'alert-error'
      when :notice
        'alert-info'
      else
        flash_type.to_s
    end
  end

end