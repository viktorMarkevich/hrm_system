class AddEventIdToStaffRelations < ActiveRecord::Migration
  def change
    add_column :staff_relations, :event_id, :integer
  end
end
