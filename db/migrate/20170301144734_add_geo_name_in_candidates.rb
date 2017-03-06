class AddGeoNameInCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :geo_name_id, :integer
  end
end
