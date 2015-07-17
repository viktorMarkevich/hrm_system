class AddDefaultStatusToStaffRelations < ActiveRecord::Migration
  def change
    change_column :staff_relations, :status, :string, default: 'Нейтральный'
  end
end
