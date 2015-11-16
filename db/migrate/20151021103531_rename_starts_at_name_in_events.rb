class RenameStartsAtNameInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :starts_at, :will_begin_at
  end
end
