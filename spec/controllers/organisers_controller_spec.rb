require 'rails_helper'

RSpec.describe OrganisersController, type: :controller do
  describe '#index' do
    let!(:user) { create :user_with_events }
    let(:old_event) { o_e = build :event, will_begin_at: user.events.first.will_begin_at - 10.days,
                                          user_id: user.id
                      o_e.save(validate: false)
                      o_e }
    let(:sticker) { create :sticker }
    let!(:candidate) { create :candidate }
    let!(:vacancy) { create :vacancy }
    let!(:sr) { create :staff_relation, vacancy_id: vacancy.id, candidate_id: candidate.id }

    before { sign_in user }

    context 'to check the stickers, the events and the vacancies' do
      before { get :index }

      it 'has HTTP 200 status' do
        expect(response).to have_http_status(200)
        expect(response).to render_template('index')
      end

      it 'to get the events' do
        expect(assigns(:events).count).to eq(5)
        expect(assigns(:events)).to eq(user.events.where(will_begin_at: Time.zone.now..(Time.zone.now + 7.days)).
                                                   order(will_begin_at: :asc))
        expect(assigns(:events)).to_not include(old_event)
      end

      it 'to get the stickers, vacancies' do
        expect(assigns(:stickers)).to eq(user.stickers)
      end

      it 'vacancy should have status "Найденные"' do
        expect(sr.status).to eq 'Найденные'
      end

      it 'to get change_history' do
        expect(assigns(:history_events).count).to eq 3
        expect(assigns(:history_events).map(&:new_status)).to eq [ 'Найденные', "Добавлена вакансия: #{vacancy.name}", "Добавлен кандидат: #{candidate.name}" ]
      end

    end
  end
end