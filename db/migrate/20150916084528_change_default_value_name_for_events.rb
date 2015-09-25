class ChangeDefaultValueNameForEvents < ActiveRecord::Migration
  def change
    change_column :events, :name, :string, default: nil
  end
end
