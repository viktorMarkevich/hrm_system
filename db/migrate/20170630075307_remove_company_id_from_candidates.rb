class RemoveCompanyIdFromCandidates < ActiveRecord::Migration[5.0]
  def change
    remove_column :candidates, :company_id
  end
end
