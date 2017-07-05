require 'rails_helper'

RSpec.describe OrganisersController, type: :controller do

  let(:user) { create :user_with_events }
  let(:candidate_user) { create :user }
  let(:region) { 'Region' }
  let!(:candidate_0) { create :candidate, user_id: candidate_user.id }
  let!(:vacancy_0) { create :vacancy, user_id: user.id, region: region }
  let!(:sr_0) { create :staff_relation, vacancy_id: vacancy_0.id, candidate_id: candidate_0.id }
  let(:old_event) { o_e = build :event, will_begin_at: user.events.first.will_begin_at - 10.days,
                                user_id: user.id, staff_relation_id: sr_0.id
                    o_e.save(validate: false)
                    o_e }
  let(:sticker) { create :sticker }
  let!(:candidate) { create :candidate, user_id: candidate_user.id }
  let!(:vacancy) { create :vacancy, user_id: user.id, region: region }
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
        expect(assigns(:events).order(will_begin_at: :asc)).to eq(user.events.where(will_begin_at: Time.zone.now..(Time.zone.now + 7.days)).
                                                   order(will_begin_at: :asc))
        expect(assigns(:events)).to_not include(old_event)
      end

      # it 'to get the stickers, vacancies' do
      #   expect(assigns(:stickers)).to eq(user.stickers)
      # end

      it 'vacancy should have status "Найденные"' do
        expect(sr.status).to eq 'Найденные'
      end
    end

    context 'when create occurs' do

      before :each do
        get :index
      end

      it 'should return histories with target data' do
        expect(assigns(:histories).count).to eq 10
        expect(assigns(:histories).pluck(:historyable_id, :historyable_type)).to eq [[sr.id, 'StaffRelation'],
                                                                                     [vacancy.id, 'Vacancy'],
                                                                                     [candidate.id, 'Candidate'],
                                                                                     [sr_0.id, 'StaffRelation'],
                                                                                     [vacancy_0.id, 'Vacancy']
                                                                                     ] + user.events.map{ |e| [e.id, 'Event'] }.reverse
        expect(assigns(:histories).pluck(:was_changed)).to eq [   {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 5)
                                                              ].flatten
        expect(assigns(:histories).pluck(:action)).to eq [ 'create', 'create', 'create', 'create', 'create', 'create', 'create', 'create', 'create', 'create' ]
      end
    end

    context 'Vacancy actions' do
      context 'when in vacancy UPDATE occurs' do

        before do
          vacancy.update_attributes(salary: '100', salary_format: 'задейство', languages: 'задейство', status: "Не вана", requirements: 'nil')
        end

        it 'should return histories with target data' do
          get :index
          expect(assigns(:histories).count).to eq 10
          expect(assigns(:histories).pluck(:was_changed)).to eq [ {"salary"=>"[\"550\", \"100\"]",
                                                                   "status"=>"[\"Не задействована\", \"Не вана\"]",
                                                                   "languages"=>"[\"Английский, Русский\", \"задейство\"]",
                                                                   "requirements"=>"[\"Ответственный\", \"nil\"]",
                                                                   "salary_format"=>"[\"usd\", \"задейство\"]"},
                                                                  {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 4)
                                                                ].flatten
          expect(assigns(:histories).pluck(:action)).to eq [ 'update',
                                                             'create',
                                                             'create',
                                                             'create',
                                                             'create', 'create', 'create', 'create', 'create', 'create' ]
        end
      end

      context 'when in vacancy DESTROY occurs' do
        let(:vacancy_to_destroy) {vacancy}
        before do
          vacancy.destroy
        end

        it 'should return histories with target data' do
          get :index
          expect(assigns(:histories).count).to eq 10
          expect(assigns(:histories).pluck(:was_changed)).to eq [ {"status"=>"[\"Не задействована\", \"В Архиве\"]"},
                                                                  {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 4)
                                                                ].flatten
          expect(assigns(:histories).pluck(:action)).to eq [ 'destroy',
                                                             'create',
                                                             'create',
                                                             'create',
                                                             'create', 'create', 'create', 'create', 'create', 'create' ]
        end
      end

      context 'when RESTORE occurs' do
        before do
          vacancy.update_columns(deleted_at: DateTime.now)
          vacancy.restore
        end

        it 'should return histories with target data' do
          get :index
          expect(assigns(:histories).count).to eq 10
          expect(assigns(:histories).pluck(:was_changed)).to eq [ {"status"=>"[\"Не задействована\", \"Не задействована\"]"},
                                                                  {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 4)
                                                                ].flatten
          expect(assigns(:histories).pluck(:action)).to eq [ 'restore',
                                                             'create',
                                                             'create',
                                                             'create',
                                                             'create', 'create', 'create', 'create', 'create', 'create' ]
        end
      end
    end

    context 'Candidate actions' do
      context 'when in Candidate DESTROY occurs' do
        let(:candidate_to_destroy) { candidate }
        before do
          candidate.destroy
        end

        it 'should return histories with target data' do
          get :index
          expect(assigns(:histories).count).to eq 10
          expect(assigns(:histories).pluck(:was_changed)).to eq [ {"status"=>"[\"В работе\", \"В Архиве\"]"},
                                                                  {"status"=>"[\"Найденные\", \"Убрать\"]"},
                                                                  {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 3)
                                                                ].flatten
          expect(assigns(:histories).pluck(:action)).to eq [ 'destroy',
                                                             'destroy',
                                                             'create',
                                                             'create',
                                                             'create', 'create', 'create', 'create', 'create', 'create' ]
        end
      end

      context 'when RESTORE occurs' do
        before do
          candidate.update_columns(deleted_at: DateTime.now)
          candidate.restore
        end

        it 'should return histories with target data' do
          get :index
          expect(assigns(:histories).count).to eq 10
          expect(assigns(:histories).pluck(:was_changed)).to eq [ {"status"=>"[\"В работе\", \"Пассивен\"]"},
                                                                  {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 4)
                                                                ].flatten
          expect(assigns(:histories).pluck(:action)).to eq [ 'restore',
                                                             'create',
                                                             'create',
                                                             'create',
                                                             'create', 'create', 'create', 'create', 'create', 'create' ]
        end
      end
    end


    context 'StaffRelation actions' do
      context 'when in staff_relation UPDATE occurs' do
        before do
          sr.update_attributes(status: 'Собеседование')
        end

        it 'should return histories with target data' do
          get :index
          expect(assigns(:histories).count).to eq 10
          expect(assigns(:histories).pluck(:was_changed)).to eq [ { "status"=>"[\"Найденные\", \"Собеседование\"]" },
                                                                  {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 4) ].flatten
          expect(assigns(:histories).pluck(:action)).to eq [ 'update',
                                                             'create',
                                                             'create',
                                                             'create',
                                                             'create', 'create', 'create', 'create', 'create', 'create' ]
        end
      end

      context 'when in StaffRelation DESTROY occurs' do
        let(:sr_to_destroy) { sr }
        before do
          sr.destroy
        end

        it 'should return histories with target data' do
          get :index
          expect(assigns(:histories).count).to eq 10
          expect(assigns(:histories).pluck(:was_changed)).to eq [ {"status"=>"[\"Найденные\", \"Убрать\"]"},
                                                                  {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 4)
                                                                ].flatten
          expect(assigns(:histories).pluck(:action)).to eq [ 'destroy',
                                                             'create',
                                                             'create',
                                                             'create',
                                                             'create', 'create', 'create', 'create', 'create', 'create' ]
        end
      end
    end

    context 'Event actions' do
      context 'when in event UPDATE occurs' do
        let(:user_event) { user.events.last }
        let(:name) { user_event.name }

        before do
          user_event.update_attributes(name: 'Собеседование')
        end

        it 'should return histories with target data' do
          get :index
          expect(assigns(:histories).count).to eq 10
          expect(assigns(:histories).pluck(:was_changed)).to eq [ { "name"=>"[\"Name\", \"Собеседование\"]",
                                                                    "will_begin_at"=>"[nil, \"#{I18n.l(user_event.will_begin_at, format: '%d %B(%A) в %T')}\"]"},
                                                                  {"vacancy_id"=>"[nil, #{sr.vacancy_id}]", "candidate_id"=>"[nil, #{sr.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy),
                                                                  set_candidate_hash(candidate),
                                                                  {"vacancy_id"=>"[nil, #{sr_0.vacancy_id}]", "candidate_id"=>"[nil, #{sr_0.candidate_id}]"},
                                                                  set_vacancy_hash(vacancy_0),
                                                                  set_events_hash(user.events, 4)
                                                                ].flatten
          expect(assigns(:histories).pluck(:action)).to eq [ 'update',
                                                             'create',
                                                             'create',
                                                             'create', 'create', 'create', 'create', 'create', 'create', 'create' ]
        end
      end
    end
  end

  def set_vacancy_hash(vacancy)
    {"name"=>"[nil, \"#{vacancy.name}\"]",
     "region"=>"[nil, \"#{vacancy.region}\"]",
     "salary"=>"[nil, \"550\"]",
     "languages"=>"[nil, \"Английский, Русский\"]",
     "requirements"=>"[nil, \"Ответственный\"]",
     "salary_format"=>"[nil, \"usd\"]"}
  end

  def set_candidate_hash(candidate)
    {"name"=>"[nil, \"#{candidate.name}\"]",
     "email"=>"[nil, \"#{candidate.email}\"]",
     "phone"=>"[nil, \"#{candidate.phone}\"]",
     "skype"=>"[nil, \"#{candidate.skype}\"]",
     "salary"=>"[nil, \"300-500 USD\"]",
     "source"=>"[nil, \"#{candidate.source}\"]",
     "status"=>"[\"Пассивен\", \"В работе\"]",
     "birthday"=>"[nil, \"06-12-2015\"]",
     "facebook"=>"[nil, \"http://www.facebook.com/test.user\"]",
     "linkedin"=>"[nil, \"https://ua.linkedin.com/pub/test-user/9a/29/644\"]",
     "education"=>"[nil, \"Oxford\"]",
     "languages"=>"[nil, \"Английский, Русский\"]",
     "vkontakte"=>"[nil, \"http://vk.com/test_man\"]",
     "google_plus"=>"[nil, \"https://plus.google.com/u/0/109854654\"]",
     "desired_position"=>"[nil, \"Программист, язык руби\"]",
     "city_of_residence"=>"[nil, \"Киев\"]",
     "ready_to_relocate"=>"[nil, \"yes\"]"}
  end

  def set_events_hash(events, n)
    # I18n.default_locale = 'ru'
    events.last(n).reverse.each_with_object([]).each do |obj, res|
      res << { "name" => "[nil, \"Name\"]",
               "description" => "[nil, \"#{obj.description}\"]",
               "will_begin_at" => "[nil, \"#{I18n.l(obj.will_begin_at, format: '%d %B(%A) в %T')}\"]",
               "staff_relation_id" => "[nil, #{obj.staff_relation_id}]"
             }
    end
  end
end