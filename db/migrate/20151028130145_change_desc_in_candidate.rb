class ChangeDescInCandidate < ActiveRecord::Migration
  def change
    change_column :candidates, :description, :text, default: nil
  end
end
