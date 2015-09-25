class AddRegionIdInCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :region_id, :integer
  end
end
