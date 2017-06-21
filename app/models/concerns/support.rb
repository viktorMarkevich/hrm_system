module Support
  extend ActiveSupport::Concern

  def set_owner
    owner
  end

  def set_changes
    changes = self.changes
    changes.delete('created_at')
    changes.delete('updated_at')
    changes.delete('user_id') if user_id
    changes.delete('id')
    changes
  end
end