class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, default: "Интервью"
      t.datetime :starts_at

      t.timestamps null: false
    end
  end
end
