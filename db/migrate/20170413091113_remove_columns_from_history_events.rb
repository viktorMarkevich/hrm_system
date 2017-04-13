class RemoveColumnsFromHistoryEvents < ActiveRecord::Migration[5.0]
  def up
    remove_column :history_events, :history_eventable_type
    remove_column :history_events, :history_eventable_id
    remove_column :history_events, :user_id
  end

  def down
    add_column :history_events, :history_eventable_type, :string
    add_column :history_events, :history_eventable_id, :integer
    add_column :history_events, :user_id, :integer
  end
end
