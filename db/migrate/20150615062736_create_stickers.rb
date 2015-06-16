class CreateStickers < ActiveRecord::Migration
  def change
    create_table :stickers do |t|
      t.string :title
      t.string :description

      t.timestamps null: false
    end
  end
end
