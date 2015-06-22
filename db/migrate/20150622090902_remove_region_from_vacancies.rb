class RemoveRegionFromVacancies < ActiveRecord::Migration
  def change
    remove_column :vacancies, :region
  end
end
