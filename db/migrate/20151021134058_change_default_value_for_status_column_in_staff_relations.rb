# coding 'utf-8'
class ChangeDefaultValueForStatusColumnInStaffRelations < ActiveRecord::Migration
  def change
    change_column_default :staff_relations, :status, 'Найденные'
  end
end
