require 'rails_helper'

RSpec.describe OrganisersController, type: :controller do

  let(:user) { create :user_with_events }
  let(:candidate_user) { create :user }
  let!(:candidate_0) { create :candidate, user_id: candidate_user.id }
  let!(:vacancy_0) { create :vacancy, user_id: user.id }
  let!(:sr_0) { create :staff_relation, vacancy_id: vacancy_0.id, candidate_id: candidate_0.id }

  let(:old_event) { o_e = build :event, will_begin_at: user.events.first.will_begin_at - 10.days,
                                user_id: user.id, staff_relation_id: sr_0.id
  o_e.save(validate: false)
  o_e }
  let(:sticker) { create :sticker }
  let!(:candidate) { create :candidate, user_id: candidate_user.id }
  let!(:vacancy) { create :vacancy, user_id: user.id }
  let!(:sr) { create :staff_relation, vacancy_id: vacancy.id, candidate_id: candidate.id }

  before :each do
    sign_in user
  end

  describe '#index' do
    context 'to check the stickers, the events and the vacancies' do

      before :each do
        get :index
      end

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
    end

    context 'when create occurs' do
      before :each do
        get :index
      end

      it 'should return histories with target data' do
        expect(assigns(:histories).count).to eq 2
        expect(assigns(:histories).pluck(:new_status)).to eq [ 'Не задействована', 'Не задействована' ]
        expect(assigns(:histories).pluck(:responsible)).to eq [ { 'id' => candidate_user.id.to_s, 'full_name' => candidate_user.full_name },
                                                                { 'id' => user.id.to_s, 'full_name' => user.full_name } ]
        expect(assigns(:histories).pluck(:action)).to eq [ 'create', 'create' ]
      end
    end

    # context 'when in staff_relation UPDATE occurs' do
    #   before do
    #     sr.update_attributes(status: 'Собеседование')
    #   end
    #
    #   it 'should return histories with target data' do
    #     get :index
    #     expect(assigns(:histories).count).to eq 4
    #     expect(assigns(:histories).pluck(:new_status)).to eq [ 'Собеседование', 'Найденные', 'Не задействована', 'Пассивен' ]
    #     expect(assigns(:histories).pluck(:responsible)).to eq [ { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => candidate_user.id.to_s, 'full_name' => user.full_name } ]
    #     expect(assigns(:histories).pluck(:action)).to eq [ "В вакансии <strong>#{vacancy.name}</strong> для кандидата <strong>#{candidate.name}</strong> произошли изменения",
    #                                                        "В вакансию <strong>#{vacancy.name}</strong> добавили нового кандидата <strong>#{candidate.name}</strong>",
    #                                                        "В систему добавлена вакансия: <strong>#{vacancy.name}</strong>",
    #                                                        "В систему добавлен кандидат: <strong>#{candidate.name}</strong>" ]
    #   end
    # end
    #
    # context 'when in vacancy UPDATE occurs' do
    #   before do
    #     vacancy.update_attributes(name: 'Vacancy name')
    #   end
    #
    #   it 'should return histories with target data' do
    #     get :index
    #     expect(assigns(:histories).count).to eq 5
    #     expect(assigns(:histories).pluck(:new_status)).to eq [ 'Собеседование', 'Найденные', 'Не задействована', 'Пассивен' ]
    #     expect(assigns(:histories).pluck(:responsible)).to eq [ { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => candidate_user.id.to_s, 'full_name' => user.full_name } ]
    #     expect(assigns(:histories).pluck(:action)).to eq [ "В вакансии <strong>#{vacancy.name}</strong> для кандидата <strong>#{candidate.name}</strong> произошли изменения",
    #                                                        "В вакансию <strong>#{vacancy.name}</strong> добавили нового кандидата <strong>#{candidate.name}</strong>",
    #                                                        "В систему добавлена вакансия: <strong>#{vacancy.name}</strong>",
    #                                                        "В систему добавлен кандидат: <strong>#{candidate.name}</strong>" ]
    #   end
    # end
    #
    # context 'when DESTROY occurs' do
    #   let(:vacancy_name) { vacancy.name }
    #   let(:candidate_name) { candidate.name }
    #
    #   before do
    #     candidate.destroy
    #     vacancy.destroy
    #   end
    #
    #   it 'should return histories with target data' do
    #     get :index
    #     expect(assigns(:histories).count).to eq 5
    #     expect(assigns(:histories).pluck(:new_status)).to eq [ 'В архиве', 'В архиве', 'Найденные', 'Не задействована', 'Пассивен' ]
    #     expect(assigns(:histories).pluck(:responsible)).to eq [ { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => candidate_user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => candidate_user.id.to_s, 'full_name' => user.full_name } ]
    #     expect(assigns(:histories).pluck(:action)).to eq [ "Вакансия <strong>#{vacancy_name}</strong> перемещена в архив",
    #                                                        "Кандидат <strong>#{candidate_name}</strong> перемещен в архив",
    #                                                        "В вакансию <strong>#{vacancy.name}</strong> добавили нового кандидата <strong>#{candidate.name}</strong>",
    #                                                        "В систему добавлена вакансия: <strong>#{vacancy.name}</strong>",
    #                                                        "В систему добавлен кандидат: <strong>#{candidate.name}</strong>" ]
    #   end
    # end
    #
    # context 'when RESTORE occurs' do
    #   let(:candidate_restore) { create :candidate, user_id: candidate_user.id, deleted_at: DateTime.now }
    #   let(:vacancy_restore) { create :vacancy, user_id: user.id, deleted_at: DateTime.now }
    #
    #   before do
    #     candidate_restore.restore
    #     vacancy_restore.restore
    #   end
    #
    #   it 'should return histories with target data' do
    #     get :index
    #     expect(assigns(:histories).count).to eq 5
    #     expect(assigns(:histories).pluck(:new_status)).to eq [ 'Восстановлена', 'Не задействована', 'Восстановлен', 'Пассивен', 'Найденные' ]
    #     expect(assigns(:histories).pluck(:responsible)).to eq [ { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => candidate_user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => candidate_user.id.to_s, 'full_name' => user.full_name },
    #                                                             { 'id' => user.id.to_s, 'full_name' => user.full_name } ]
    #         expect(assigns(:histories).pluck(:action)).to eq [ "Вакансия <strong>#{vacancy_restore.name}</strong> восстановлена из архива",
    #                                                            "В систему добавлена вакансия: <strong>#{vacancy_restore.name}</strong>",
    #                                                        "Кандидат <strong>#{candidate_restore.name}</strong> восстановлен из архива",
    #                                                        "В систему добавлен кандидат: <strong>#{candidate_restore.name}</strong>",
    #                                                        "В вакансию <strong>#{vacancy.name}</strong> добавили нового кандидата <strong>#{candidate.name}</strong>" ]
    #   end
    # end
  end
end