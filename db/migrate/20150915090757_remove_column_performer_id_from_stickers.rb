class RemoveColumnPerformerIdFromStickers < ActiveRecord::Migration
  def change
    remove_column :stickers, :performer_id
  end
end
