module OrganizersHelper

  def set_action_for(history)
    t(set_locales_path(history) + '.notice', object_name: history.historyable.name).html_safe
  end

  def set_status_for(history)
    t(set_locales_path(history) + '.status', object_status: history.was_changed['status']).html_safe
  end

  def set_locales_path(history)
    "history.#{history.historyable_type.downcase}.#{history.action}"
  end

end
