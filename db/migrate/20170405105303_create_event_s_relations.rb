class CreateEventSRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :event_s_relations do |t|
      t.integer :event_id
      t.integer :staff_relation_id
      t.timestamps
    end
  end
end
