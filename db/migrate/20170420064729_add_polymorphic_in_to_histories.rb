class AddPolymorphicInToHistories < ActiveRecord::Migration[5.0]

  def up
    add_column :histories, :historyable_type, :string
    add_column :histories, :historyable_id, :integer

    add_index :histories, :historyable_type
    add_index :histories, :historyable_id
  end

  def down
    remove_index :histories, :historyable_type
    remove_index :histories, :historyable_id

    remove_column :histories, :historyable_type
    remove_column :histories, :historyable_id
  end
end
