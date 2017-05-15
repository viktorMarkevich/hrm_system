module OrganizersHelper

  def set_action_for(history)
    t(set_locales_path(history) + '.notice', object_name: (link_to history.historyable.name, polymorphic_url(history.historyable))).html_safe
  end

  def set_status_for(history)
    case history.action
      when 'create'
        t(set_locales_path(history) + '.changes').html_safe
      when 'update'
        t(set_locales_path(history) + '.changes', object_changes: set_changes(history.was_changed)).html_safe
      else
        []
    end
  end

  def set_locales_path(history)
    "history.#{history.historyable_type.downcase}.#{history.action}"
  end

  def set_changes(was_changed)
    was_changed.each do |k, v|
      p '*'*100
      p v
      p '*'*100
      # if v.first == nil
      #   p 'first'
      # else
      #   p 'second'
      # end
    end
  end

end
