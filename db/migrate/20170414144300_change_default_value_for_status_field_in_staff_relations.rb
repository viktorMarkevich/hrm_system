class ChangeDefaultValueForStatusFieldInStaffRelations < ActiveRecord::Migration[5.0]
  def change
    change_column :staff_relations, :status, :string, default: 'Найденные'
  end
end
