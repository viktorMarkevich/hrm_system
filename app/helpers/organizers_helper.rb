module OrganizersHelper

  def set_owner_for_historyable(history)
    owner = history.historyable.set_owner
    link_to owner.full_name, user_path(owner)
  end

  def set_action_for(history)
    if history.historyable_type != 'StaffRelation'
      t(set_locales_path(history) + '.notice', object_name: (link_to history.historyable.name, polymorphic_url(history.historyable))).html_safe
    else
      p '*'*100
      p history.historyable
      p '*'*100

      vacancy = history.historyable.vacancy
      candidate = history.historyable.candidate
      t(set_locales_path(history) + '.notice', vacancy_name: (link_to vacancy.name, vacancy_path(vacancy)),
                                               candidate_name: (link_to candidate.name, candidate_path(candidate))).html_safe
    end
  end

  def set_status_for(history)
    history.was_changed.map do |attribute, v|
      values = v.gsub(/["\[\]]/, '').split(', ')
      if "#{values[1]}" != '' && !in_exception_list?(attribute, history)
        (t("activerecord.attributes.#{set_model_name(history)}.#{attribute}") +
            t(set_locales_path(history) + '.changes', val_from: (values[0] == 'nil' || values[0] == '' ? 'Пусто' : values[0]),
              val_to: (values[1] == 'nil' ? nil : values[1])))
      end
    end.compact.join('; ').html_safe
  end

  def set_locales_path(history)
    "history.#{set_model_name(history)}.#{history.action}"
  end

  def set_model_name(history)
    history.historyable_type.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  end

  def in_exception_list?(attr, history)
    Object.const_get(history.historyable_type)::TRANSLATE_EXCEPTION.include?(attr)
  end

end