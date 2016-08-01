class CreateHistoryEvents < ActiveRecord::Migration
  def change
    create_table :history_events do |t|
      t.integer :record_id
      t.string :name
      t.string :user
      t.text :body

      t.timestamps null: false
    end
  end
end
