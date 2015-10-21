class RenameOwnerIdToUserIdForStickers < ActiveRecord::Migration
  def change
    rename_column :stickers, :owner_id, :user_id
  end
end
