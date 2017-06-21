class AddColumnExperienceToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :experience, :text
  end
end
