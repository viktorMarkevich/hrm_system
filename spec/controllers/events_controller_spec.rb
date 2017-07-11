require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  let(:json) { JSON.parse(response.body) }
  render_views

  let! (:current_user) { create :user_with_events }
  let! (:user) { create :user_with_events, events_count: 2 }

  before do
     sign_in current_user
  end

  def start_date
    Time.zone.now
  end

  def end_date
    start_date.end_of_month
  end

  def events_of(user, from, to)
    user.events.where(will_begin_at: from..to).order(will_begin_at: :asc)
  end

  def err_messages
    [ 'Название не может быть пустым', 'Описание не может быть пустым', 'Начало должно быть предстоящим' ]
  end

  context '#index' do
    before { get :index  }

    it 'has successful response; has HTTP 200 status; renders "index" template' do
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('index')
    end

    it 'assigns future events as @events' do
      expect(assigns(:events).length).to eq(events_of(current_user, start_date, end_date).count)
      expect(assigns(:events)).to eq(events_of(current_user, start_date, end_date))
    end

    it 'assigns old events as @events' do
      expect(assigns(:events_past)).to eq(events_of(current_user, start_date.beginning_of_month, start_date))
      expect(assigns(:events_past).length).to eq(events_of(current_user, start_date.beginning_of_month, start_date).count)
    end
  end

  describe '#create action;' do
    let (:event_params) { attributes_for :event }
    let (:will_begin_at) { (Time.zone.now.utc + 10.hours + 12.minutes).round.iso8601(0) }

    context 'when successful without "staff_relations"' do
      before { post :create, params: { event: event_params.update(will_begin_at: will_begin_at,
                                                                  user_id: current_user.id), format: :json } }

      it 'creates new Event object' do
        expect(json).to eq JSON.parse((attributes_for :event).to_json).update(
                               'vacancy_name' => '------',
                               'candidate_name' => '------',
                               'update_path' => '<a class="glyphicon glyphicon-edit" data-remote="true" href='"#{event_path(Event.last)}"'></a>',
                               'destroy_path' => '<a data-confirm="Вы уверены?" class="glyphicon glyphicon-remove" rel="nofollow" data-method="delete" href='"#{event_path(Event.last)}"'></a>',
                               'will_begin_at' => "#{will_begin_at}" )
        expect(response).to have_http_status(:created)
      end
    end

    context 'when successful with "staff_relations"' do
      let (:staff_relation) { create :staff_relation, status: 'Собеседование' }
      let (:vacancy) { create(:vacancy) }
      let (:candidate) { create(:candidate) }

      before { post :create, params: { event: event_params.update(will_begin_at: will_begin_at,
                                                                  staff_relation_attributes: { vacancy_id: vacancy.id, candidate_id: candidate.id },
                                                                  user_id: current_user.id), format: :json } }

      it 'creates new Event object' do
        expect(json).to eq JSON.parse((attributes_for :event).to_json).update(
                               'name' => 'Name',
                               'vacancy_name' => "#{Event.last.staff_relation.vacancy.name}",
                               'candidate_name' => "#{Event.last.staff_relation.candidate.name}",
                               'update_path' => '<a class="glyphicon glyphicon-edit" data-remote="true" href='"#{event_path(Event.last)}"'></a>',
                               'destroy_path' => '<a data-confirm="Вы уверены?" class="glyphicon glyphicon-remove" rel="nofollow" data-method="delete" href='"#{event_path(Event.last)}"'></a>',
                               'will_begin_at' => "#{will_begin_at}" )
        expect(response).to have_http_status(:created)
      end
    end

    context 'when failed' do
      let (:invalid_event_params) { { event: (attributes_for :invalid_event, user_id: current_user.id), format: :json } }
      before { post :create, params: invalid_event_params }

      it %q{ doesn't create new record } do
        expect(json).not_to eq JSON.parse((attributes_for :event).to_json).update( vacancy_name: nil,
                                                                                   candidate_name: nil,
                                                                                   update_path: "#{event_path(Event.last)}",
                                                                                   destroy_path: "#{event_path(Event.last)}",
                                                                                   will_begin_at: nil )
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'error messages' do
        expect(json['errors']).to eq(err_messages)
      end
    end
  end

  describe '#update' do
    let (:event) { current_user.events.first }
    let (:staff_relation) { create(:staff_relation) }
    let (:vacancy) { create(:vacancy) }
    let (:candidate) { create(:candidate) }
    let (:will_begin_at) { (Time.zone.now.utc + 1.day + 12.minutes).round.iso8601(0) }
    let (:event_attrs) { {  description: 'Редактирование описания', name: 'Name', will_begin_at: "#{ will_begin_at }",
                            staff_relation_attributes: { vacancy_id: vacancy.id, candidate_id: candidate.id, status: 'Собеседование' } } }

    context 'when successful should return updated event' do
      before do
        put :update, params: { id: event, event: event_attrs, format: :json }
        event.reload
      end

      it 'has updated name' do
        expect(response).to have_http_status(200)
      end

      it 'has updated attrs' do
        expect(assigns(:event).description).to eq 'Редактирование описания'
        expect(assigns(:event).name).to eq 'Name'
        expect(assigns(:event).will_begin_at).to eq will_begin_at
        expect(assigns(:event).staff_relation).to eq StaffRelation.last
        expect(assigns(:event).staff_relation.status).to eq StaffRelation.last.status
      end

      it 'should return json data' do
        expect(json).to eq({ 'eventName' => event.name,
                             'eventId' => event.id,
                            'vacancyLink' => "<a href=\"/vacancies/#{event.staff_relation.vacancy_id}\">#{event.staff_relation.vacancy.name}</a>",
                            'candidateLink' => "<a href=\"/candidates/#{event.staff_relation.candidate_id}\">#{event.staff_relation.candidate.name}</a>",
                            'eventData' => event.will_begin_at.strftime('%e %b %H:%M') })
      end
    end

    context 'when failed' do
      before do
        put :update, params: { id: event, event: (attributes_for :invalid_event), format: :json}
      end

      it 'renders "edit" template' do
        expect(assigns(:event).errors.full_messages).to eq(err_messages)
      end
    end
  end

  context '#destroy' do
    let (:event) { current_user.events.first }
    let (:id) { event.id }

    before do
      delete :destroy, params: { id: event }
    end

    it 'destroys event' do
      expect(Event.pluck(:id)).not_to include(id)
    end

    it 'redirects to events index page' do
      expect(response).to redirect_to(events_path)
    end
  end

  context 'mail send' do
    let(:candidate) { create :candidate }
    let(:vacancy) { create :vacancy }
    let(:staff_relation) { create :staff_relation, candidate_id: candidate.id, vacancy_id: vacancy.id }
    let(:event) { current_user.events.first }

    before :each do
      event.update_attributes(staff_relation_id: staff_relation.id)
      event.reload
    end

    it 'has send mail' do
      expect { NoticeMailer.event_soon(event, event.staff_relation.candidate.owner).deliver_now }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end

end