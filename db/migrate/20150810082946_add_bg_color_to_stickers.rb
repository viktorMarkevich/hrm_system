class AddBgColorToStickers < ActiveRecord::Migration
  def change
    add_column :stickers, :bg_color, :string
  end
end
