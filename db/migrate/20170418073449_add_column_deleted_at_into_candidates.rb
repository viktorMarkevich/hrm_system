class AddColumnDeletedAtIntoCandidates < ActiveRecord::Migration[5.0]
  def up
    add_column :candidates, :deleted_at, :datetime
    add_index :candidates, :deleted_at
  end

  def down
    remove_index :candidates, :deleted_at
    remove_column :candidates, :deleted_at
  end
end
