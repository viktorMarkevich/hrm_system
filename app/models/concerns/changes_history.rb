module ChangesHistory
  extend ActiveSupport::Concern

private
  def write_history
    if !self.previous_changes.blank?
      prev_hash = self.previous_changes.to_hash.symbolize_keys.compact.except(:updated_at)
      changes_hash = prev_hash.each{|k,v| !v[1].blank? && v[1] != 0 && v.uniq.size != 1 || prev_hash.delete(k)}
      history_event = HistoryEvent.create(record_id: self.id, name: self.class.table_name, user: User.current_user.try(:id), body: changes_hash)
      history_event.save!
    else
      return self.errors[:messages]
    end
  end

end