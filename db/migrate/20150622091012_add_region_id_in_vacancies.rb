class AddRegionIdInVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :region_id, :integer
  end
end
