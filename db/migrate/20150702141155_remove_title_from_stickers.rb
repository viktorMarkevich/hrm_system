class RemoveTitleFromStickers < ActiveRecord::Migration
  def change
    remove_column :stickers, :title, :string
  end
end
