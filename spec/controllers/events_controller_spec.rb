require 'rails_helper'

RSpec.describe EventsController, type: :controller do
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
    ["Name can't be blank", "Description can't be blank", "Will begin at Дата должна быть предстоящей!"]
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
    let (:will_begin_at) { (Time.zone.now + 10.hours + 12.minutes).strftime("%FT%T%:z") }
    let (:json_response) { JSON.parse(response.body) }

    context 'when successful without "staff_relations"' do
      before { post :create, params: { event: event_params.update(will_begin_at: will_begin_at,
                                                                  user_id: current_user.id), format: :json } }

      it 'creates new Event object' do
        json = JSON.parse((attributes_for :event).to_json).update(
              'vacancy_name' => '------',
              'candidate_name' => '------',
              'update_path' => '<a class="glyphicon glyphicon-edit" data-remote="true" href='"#{edit_event_path(Event.last)}"'></a>',
              'destroy_path' => '<a data-confirm="Вы уверены?" class="glyphicon glyphicon-remove" rel="nofollow" data-method="delete" href='"#{event_path(Event.last)}"'></a>',
              'will_begin_at' => "#{will_begin_at}"
              )
        expect(json_response).to eq json
        expect(response).to have_http_status(:created)
      end
    end

    context 'when successful with "staff_relations"' do
      let (:staff_relation) { create :staff_relation, status: 'Собеседование' }
      before { post :create, params: { event: event_params.update(will_begin_at: will_begin_at,
                                                                  staff_relation: staff_relation.id,
                                                                  user_id: current_user.id), format: :json } }

      it 'creates new Event object' do
        json = JSON.parse((attributes_for :event).to_json).update(
            'name' => "#{staff_relation.status}",
            'vacancy_name' => "#{Event.last.staff_relation.vacancy.name}",
            'candidate_name' => "#{Event.last.staff_relation.candidate.name}",
            'update_path' => '<a class="glyphicon glyphicon-edit" data-remote="true" href='"#{edit_event_path(Event.last)}"'></a>',
            'destroy_path' => '<a data-confirm="Вы уверены?" class="glyphicon glyphicon-remove" rel="nofollow" data-method="delete" href='"#{event_path(Event.last)}"'></a>',
            'will_begin_at' => "#{will_begin_at}"
            )
        expect(json_response).to eq json
        expect(response).to have_http_status(:created)
      end
    end

    context 'when failed' do
      let (:invalid_event_params) { { event: (attributes_for :invalid_event,
                                                            user_id: current_user.id), format: :json } }
      before { post :create, params: invalid_event_params }

      it %q{ doesn't create new record } do
        json = JSON.parse((attributes_for :event).to_json).update(
            'vacancy_name' => nil,
            'candidate_name' => nil,
            'update_path' => "#{edit_event_path(Event.last)}",
            'destroy_path' => "#{event_path(Event.last)}",
            'will_begin_at' => nil
            )
        expect(json_response).not_to eq json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'error messages' do
        expect(json_response['errors']).to eq(err_messages)
      end
    end
  end

  context '#edit' do
    let (:event) { current_user.events.first }
    before { get :edit, params: { id: current_user.events.first } }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).not_to render_template('edit')
    end

    it 'assigns event for edit' do
      expect(assigns(:event)).to eq(event)
    end
  end

  describe '#update' do
    let (:event) { current_user.events.first }
    let (:staff_relation) { create(:staff_relation) }
    let (:event_attrs) { { name: 'Name', description: 'Редактирование описания' } }

    context 'when successful' do
      before do
        put :update, params: { id: event, event: event_attrs, staff_relation: staff_relation.id, format: :js }
        event.reload
      end

      it 'has updated name' do
        expect(event.name).to eql event_attrs[:name]
      end

      it 'redirects to events index page' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when failed' do
      before do
        put :update, params: { id: event, event: (attributes_for :invalid_event),
                               staff_relation: staff_relation.id, format: :json}
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
end

