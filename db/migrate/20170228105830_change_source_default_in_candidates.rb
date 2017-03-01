class ChangeSourceDefaultInCandidates < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:candidates, :source, nil)
  end
end
