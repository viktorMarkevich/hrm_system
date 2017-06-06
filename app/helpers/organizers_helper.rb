module OrganizersHelper

  def set_owner_for_historyable(history)
    if history.historyable_type != 'StaffRelation'
      link_to history.historyable.owner.full_name, user_path(history.historyable.owner)
    else
      owner = history.historyable.vacancy.owner
      link_to owner.full_name, user_path(owner)
    end
  end

  def set_action_for(history)
    if history.historyable_type != 'StaffRelation'
      t(set_locales_path(history) + '.notice', object_name: (link_to history.historyable.name, polymorphic_url(history.historyable))).html_safe
    else
      vacancy = history.historyable.vacancy
      candidate = history.historyable.candidate
      t(set_locales_path(history) + '.notice', vacancy_name: (link_to vacancy.name, vacancy_path(vacancy)),
                                               candidate_name: (link_to candidate.name, candidate_path(candidate))).html_safe
    end
  end

  def set_status_for(history)
    case history.action
      when 'create'
        t(set_locales_path(history) + '.changes').html_safe
      when 'update'
        t(set_locales_path(history) + '.changes', object_changes: set_changes(history)).html_safe
      else
        'Уведомление отсутствует'
    end
  end

  def set_locales_path(history)
    "history.#{history.historyable_type.downcase}.#{history.action}"
  end
  def set_changes(history)
    history.was_changed.map do |attribute, v|
      values = v.gsub(/["\[\],]/, '').split(' ')
      if "#{values[1]}" != ''
        t("activerecord.attributes.vacancy.#{attribute}") + ' изменилась с ' + "<span style='color: red;'>#{values[0] == 'nil' ? 'Пусто' : values[0]}</span>" + ' на ' + "<span style='color: red;'>#{values[1]}</span>"
      end
    end.join('; ')
  end

end
