class RemoveSourceRefFromCandidates < ActiveRecord::Migration[5.0]
  def change
    remove_reference :candidates, :cv_source, foreign_key: true
  end
end
