class AddColumnSrIdToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :staff_relation_id, :integer
  end
end
