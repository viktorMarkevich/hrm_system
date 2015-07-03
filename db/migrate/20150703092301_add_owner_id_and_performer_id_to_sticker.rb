class AddOwnerIdAndPerformerIdToSticker < ActiveRecord::Migration
  def change
    add_column :stickers, :owner_id, :integer
    add_column :stickers, :performer_id, :integer
  end
end
