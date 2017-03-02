class ChangeFieldHistoryEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :history_events, :name
    remove_column :history_events, :record_id
    remove_column :history_events, :body
    add_column :history_events, :history_eventable_type, :string
    add_column :history_events, :history_eventable_id, :integer
    add_column :history_events, :old_status, :string
    add_column :history_events, :new_status, :string
  end
end
