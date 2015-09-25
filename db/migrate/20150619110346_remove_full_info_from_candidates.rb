class RemoveFullInfoFromCandidates < ActiveRecord::Migration
  def change
    remove_column :candidates, :full_info
  end
end
