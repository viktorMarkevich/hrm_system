class AddCandidatesCountInToCompanies < ActiveRecord::Migration[5.0]
  def up
    add_column :companies, :candidates_count, :integer
  end

  def down
    remove_column :companies, :candidates_count
  end
end
