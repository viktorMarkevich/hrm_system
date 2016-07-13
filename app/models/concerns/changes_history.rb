module ChangesHistory
  extend ActiveSupport::Concern

private
  def write_history
    if !self.previous_changes.blank?
      history_event = HistoryEvent.create(name: self.class.table_name, user: self.owner, body: self.previous_changes.to_hash)
      history_event.save!
    else
      return self.errors[:messages]
    end
  end

end