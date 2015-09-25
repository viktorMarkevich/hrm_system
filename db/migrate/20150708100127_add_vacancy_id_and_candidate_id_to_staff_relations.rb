class AddVacancyIdAndCandidateIdToStaffRelations < ActiveRecord::Migration
  def change
    add_column :staff_relations, :vacancy_id, :integer
    add_column :staff_relations, :candidate_id, :integer
  end
end
