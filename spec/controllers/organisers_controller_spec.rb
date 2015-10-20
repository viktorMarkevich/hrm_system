require 'rails_helper'

RSpec.describe OrganisersController, type: :controller do

  let(:user) { create(:user) }
  let(:event) { create(:event, user_id: user) }
  let(:sticker) { create(:sticker, owner_id: user.id) }
  let(:candidate) { create(:candidate, user_id: user.id) }
  let(:vacancy) { create(:vacancy, user_id: user.id) }
  let(:sr) { create(:staff_relation, vacancy_id: vacancy, candidate_id: candidate )}

  before { sign_in user }

  describe '#index' do
    context 'to check the stickers, the events and the vacancies' do

      before { get :index }

      it 'has HTTP 200 status' do
        expect(response).to have_http_status(200)
        expect(response).to render_template('index')
      end

      it 'to get the events, stickers, vacancies' do
        expect(assigns(:events)).to eq([event])
        expect(assigns(:stickers)).to eq([sticker])
        expect(assigns(:staff_relations)).to eq([sr])
      end

    end
  end
end