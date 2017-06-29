class ChnageIndexForWasChangedInHistories < ActiveRecord::Migration[5.0]
  def up
    remove_index :histories, :was_changed
    add_index :histories, :was_changed, using: :gist
  end

  def down
    remove_index :histories, :was_changed
    add_index :histories, :was_changed, using: :gin
  end
end
