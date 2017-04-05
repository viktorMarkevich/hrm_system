class RemoveColumnStaffRelation < ActiveRecord::Migration[5.0]
  def change
    remove_column :staff_relations, :event_id
    remove_column :staff_relations, :notice
  end
end
