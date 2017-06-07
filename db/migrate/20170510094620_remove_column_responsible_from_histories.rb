class RemoveColumnResponsibleFromHistories < ActiveRecord::Migration[5.0]
  def up
    remove_index :histories, :responsible
    remove_column :histories, :responsible
  end

  def down
    enable_extension 'hstore'
    add_column :histories, :responsible, :hstore
    add_index :histories, :responsible, using: :gin
  end
end
