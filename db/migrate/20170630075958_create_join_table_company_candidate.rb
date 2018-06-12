class CreateJoinTableCompanyCandidate < ActiveRecord::Migration[5.0]
  def change
    create_join_table :companies, :candidates do |t|
      t.index [:company_id, :candidate_id], name: 'com_id_can_id'
    end
  end
end
