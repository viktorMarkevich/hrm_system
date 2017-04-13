class RenameHistoryEventsInToHistories < ActiveRecord::Migration[5.0]
  def up
    rename_table :history_events, :histories
  end

  def down
    rename_table :histories, :history_events
  end
end
