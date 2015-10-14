class RemoveExperienceColumnFromCandidates < ActiveRecord::Migration
  def change
    remove_column :candidates, :experience
  end
end
