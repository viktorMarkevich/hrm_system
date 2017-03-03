class CreateGeoAlternateNames < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_alternate_names do |t|
      t.integer :geo_geoname_id
      t.string :language
      t.string :name
      t.string :alternate_name
      t.timestamps
    end
  end
end
