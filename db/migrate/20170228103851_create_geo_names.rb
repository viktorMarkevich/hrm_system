class CreateGeoNames < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_names do |t|
      t.string :name
      t.string :asciiname
      t.decimal :lat
      t.decimal :lng
      t.string :fclass
      t.string :fcode
      t.string :country
      t.string :cc2
      t.string :admin1
      t.string :admin2
      t.string :admin3
      t.string :admin4
      t.integer :population
      t.integer :elevation
      t.integer :gtopo30
      t.string :timezone
      t.timestamps
    end
  end
end
