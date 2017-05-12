module OrganizersHelper

  def set_action_for(history)
    t(set_locales_path(history) + '.notice', object_name: history.historyable.name).html_safe
  end

  def set_status_for(history)
    case history.action
      when 'create'
        t(set_locales_path(history) + '.changes', object_status: history.was_changed['status']).html_safe
      when 'update'
        t(set_locales_path(history) + '.changes', object_changes: set_changes(history.was_changed)).html_safe
      else
        []
    end
  end

  def set_locales_path(history)
    "history.#{history.historyable_type.downcase}.#{history.action}"
  end

end
