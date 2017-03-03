class RenameDescriptionToOriginalCvDataInCandidates < ActiveRecord::Migration[5.0]
  def change
    rename_column :candidates, :description, :original_cv_data
  end
end
