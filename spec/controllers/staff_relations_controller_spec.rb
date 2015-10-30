require 'rails_helper'

RSpec.describe StaffRelationsController, type: :controller do
  describe 'should to mark a candidate as found' do
    let(:candidates_list) { create_list(:candidate, 2) }
    let(:vacancy) { create :vacancy }

    let(:staff_relation_params) { { staff_relation: { vacancy_id: vacancy.id,
                                                      candidate_id: { candidates_list.first.id.to_s => '1',
                                                                      candidates_list.last.id.to_s => '1' } } } }
    before do
      post :create, staff_relation_params
      vacancy.reload
    end

    it 'updates candidates status on "В работе"' do
      expect(vacancy.status).to eq 'В работе'
    end
  end
end
