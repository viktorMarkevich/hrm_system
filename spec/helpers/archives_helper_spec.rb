require 'rails_helper'

RSpec.describe ArchivesHelper, type: :helper do

  # let(:user) { create :user}
  # let(:vacancy) { create :vacancy }
  let(:candidate) { create :candidate }
  # let!(:staff_relation) { create :staff_relation, vacancy_id: vacancy.id, candidate_id: candidate.id }

  context 'methods helper' do
    it 'method desired_salary_for' do
      expect(helper.object_path([candidate])).to eq('/candidates')
    end
  end
end