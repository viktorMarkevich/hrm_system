class AddCompanyIdToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :company_id, :integer, default: nil
  end
end
