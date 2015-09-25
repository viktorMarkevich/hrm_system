class ChangeDefaultStatusToNilInStaffRelations < ActiveRecord::Migration
  def change
    change_column :staff_relations, :status, :string, default: nil
  end
end
