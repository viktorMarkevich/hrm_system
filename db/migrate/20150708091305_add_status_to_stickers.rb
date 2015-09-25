class AddStatusToStickers < ActiveRecord::Migration
  def change
    add_column :stickers, :status, :string
  end
end
