class RemoveColumnStatusFromStickers < ActiveRecord::Migration
  def change
    remove_column :stickers, :status
  end
end
