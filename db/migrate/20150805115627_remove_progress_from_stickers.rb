class RemoveProgressFromStickers < ActiveRecord::Migration
  def change
    remove_column :stickers, :progress, :string
  end
end
