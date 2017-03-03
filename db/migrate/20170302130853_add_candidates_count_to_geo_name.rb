class AddCandidatesCountToGeoName < ActiveRecord::Migration[5.0]
  def change
    add_column :geo_names, :candidates_count, :integer, default: 0
  end
end
