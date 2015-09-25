class RemoveRegionFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :region
  end
end
