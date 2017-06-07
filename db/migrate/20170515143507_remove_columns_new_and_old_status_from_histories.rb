class RemoveColumnsNewAndOldStatusFromHistories < ActiveRecord::Migration[5.0]

  def up
    remove_column :histories, :new_status
    remove_column :histories, :old_status
  end

  def down
    add_column :histories, :new_status, :string
    add_column :histories, :old_status, :string
  end
end
