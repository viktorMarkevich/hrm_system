class CreateCvSources < ActiveRecord::Migration[5.0]
  def change
    create_table :cv_sources do |t|
      t.string :name

      t.timestamps
      t.index ['name'], name: 'index_cv_sources_on_name', unique: true, using: :btree
    end
  end
end
