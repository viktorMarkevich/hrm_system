require 'rails_helper'

RSpec.describe OrganisersController, type: :controller do

  let(:user) { create(:user_with_events) }
  let(:old_event) { o_e = build(:event, will_begin_at: user.events.first.will_begin_at - 10.days)
                    o_e.save(validate: false)
                    o_e }
  let(:sticker) { create(:sticker) }
  let(:candidate) { create(:candidate) }
  let(:vacancy) { create(:vacancy) }
  let(:sr) { create(:staff_relation )}

  before { sign_in user }

  describe '#index' do
    context 'to check the stickers, the events and the vacancies' do

      before { get :index }

      it 'has HTTP 200 status' do
        expect(response).to have_http_status(200)
        expect(response).to render_template('index')
      end

      it 'to get the events, stickers, vacancies' do
        expect(assigns(:events)).to eq(user.events.order(will_begin_at: :asc))
        expect(assigns(:events)).to_not include(old_event)
        expect(assigns(:stickers)).to eq(user.stickers)
        expect(assigns(:staff_relations)).to eq([sr])
      end

    end

    describe 'to check the last vacancies actions' do
      context 'just check the vacancy status after creation' do
        it 'vacancies' do
          expect(sr.status).to eq 'Найденные'
        end
      end
    end
  end
end