class AddColumnActionInToHistories < ActiveRecord::Migration[5.0]
  def up
    add_column :histories, :action, :string
  end

  def down
    remove_column :histories, :action
  end
end
