class RemoveAddNewColumnFromUsersAndCompanies < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :region_id
    add_column :users, :region, :string

    remove_column :companies, :region_id
    add_column :companies, :region, :string
  end

  def down
    remove_column :users, :region
    add_column :users, :region_id, :integer

    remove_column :companies, :region
    add_column :companies, :region_id, :integer
  end
end
