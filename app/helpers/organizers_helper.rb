module OrganizersHelper

  def set_action_for(history)
    t(set_locales_path(history) + '.notice', object_name: (link_to history.historyable.name, polymorphic_url(history.historyable))).html_safe
  end

  def set_status_for(history)
    case history.action
      when 'create'
        t(set_locales_path(history) + '.changes').html_safe
      when 'update'
        t(set_locales_path(history) + '.changes', object_changes: set_changes(history)).html_safe
      else
        []
    end
  end

  def set_locales_path(history)
    "history.#{history.historyable_type.downcase}.#{history.action}"
  end

  def set_changes(history)
    history.was_changed.map do |k, v|
      values = v.gsub(/["\[\],]/, '').split(' ')
      if "#{values[1]}" != ''
        t("activerecord.attributes.vacancy.#{k}") + ' изменилась с ' + "<span style='color: red;'>#{values[0]}</span>" + ' на ' + "<span style='color: red;'>#{values[1]}</span>"
      end
    end.join('; ')
  end

end
