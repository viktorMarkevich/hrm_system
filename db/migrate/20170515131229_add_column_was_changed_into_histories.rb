class AddColumnWasChangedIntoHistories < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'hstore'
    add_column :histories, :was_changed, :hstore
    add_index :histories, :was_changed, using: :gin
  end

  def down
    remove_index :histories, :was_changed
    remove_column :histories, :was_changed
  end
end
