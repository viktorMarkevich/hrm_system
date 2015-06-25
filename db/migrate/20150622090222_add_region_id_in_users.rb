class AddRegionIdInUsers < ActiveRecord::Migration
  def up
    add_column :users, :region_id, :integer
  end

  def down
    remove_column :users, :region_id
  end
end
