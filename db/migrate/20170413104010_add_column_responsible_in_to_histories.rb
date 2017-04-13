class AddColumnResponsibleInToHistories < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'hstore'
    add_column :histories, :responsible, :hstore
    add_index :histories, :responsible, using: :gin
  end

  def down
    remove_index :histories, :responsible
    remove_column :histories, :responsible
  end
end
