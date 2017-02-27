class AddCvSourceRefToCandidates < ActiveRecord::Migration[5.0]
  def change
    add_reference :candidates, :cv_source, foreign_key: true
  end
end
