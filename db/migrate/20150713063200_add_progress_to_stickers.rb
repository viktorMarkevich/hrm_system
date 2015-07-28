class AddProgressToStickers < ActiveRecord::Migration
  def change
    add_column :stickers, :progress, :string
  end
end
