module OrganizersHelper

  def set_action_for(history)
    t(set_locales_path(history), object_name: history.historyable.name).html_safe
  end

  def set_responsible_for(history)
    t(set_locales_path(history), responsible_id: history.responsible['id'],
                                 responsible_name: history.responsible['full_name']).html_safe
  end

  def set_status_for(history)
    if old_status.present?
      t(set_locales_path(history), responsible_id: history.responsible['id'],
                                   responsible_name: history.responsible['full_name']).html_safe
    else
      t(set_locales_path(history), responsible_id: history.responsible['id'],
        responsible_name: history.responsible['full_name']).html_safe
    end
  end

  def set_locales_path(history)
    "history.#{history.historyable_type.downcase}.#{history.action}"
  end

end
