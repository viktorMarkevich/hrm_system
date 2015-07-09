class CreateStaffRelations < ActiveRecord::Migration
  def change
    create_table :staff_relations do |t|
      t.string :status
      t.text :notice

      t.timestamps null: false
    end
  end
end
