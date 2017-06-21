require 'rails_helper'

RSpec.describe StaffRelationsController, type: :controller do
  describe 'should to mark a candidate as found' do
    let(:candidates_list) { create_list(:candidate, 2) }
    let(:vacancy) { create :vacancy }

    let(:staff_relation_params) { { staff_relation: { vacancy_id: vacancy.id,
                                                      candidate_id: [ candidates_list.first.id,
                                                                      candidates_list.last.id ] } } }
    let!(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'updates candidates status on "В работе"' do
      post :create, params: staff_relation_params, format: :json
      vacancy.reload

      expect(assigns(:vacancy).status).to eq 'В работе'
      expect(StaffRelation.count).to eq(2)
    end
  end
end
