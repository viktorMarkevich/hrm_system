require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:current_user) { create(:user_with_events) }
  let!(:user) { create(:user_with_events, events_count: 2) }

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

  context '#new' do
    before { get :new }

    it 'has HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders "new" template' do
      expect(response).not_to render_template('new')
    end

    it 'creates an instance of Event class' do
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe '#create action;' do
    let(:event_params) { attributes_for :event }

    context 'when successful without "staff_relations"' do
      let (:will_begin_at) { (Time.zone.now + 10.hours + 12.minutes).strftime("%FT%T%:z") }
      before { post :create, params: {event: event_params.update(will_begin_at: will_begin_at,
                                                        user_id: current_user.id), format: :js }}

      it 'creates new Event object' do
        expect(assigns(:events).length).to eq(events_of(current_user, start_date, end_date).count)
        expect(assigns(:event).will_begin_at).to eq will_begin_at
        expect(assigns(:event).name).to eq 'Name'
      end
    end

    context 'when successful with "staff_relations"' do
      let(:staff_relation) { create(:staff_relation, status: 'Собеседование') }
      before { post :create, params: {event: event_params.update(staff_relation: staff_relation.id,
                                                        user_id: current_user.id), format: :js }}

      it 'creates new Event object' do
        expect(assigns(:events).length).to eq(events_of(current_user, start_date, end_date).count)
        expect(assigns(:event).name).to eq staff_relation.status
      end
    end

    context 'when failed' do
      let(:invalid_event_params) { { event: (attributes_for :invalid_event,
                                                            user_id: current_user.id), format: :json } }
      before { post :create, params: invalid_event_params }

      it %q{ doesn't create new record } do
        expect(assigns(:events).length).to eq(events_of(current_user, start_date, end_date).count)
      end

      it 'error messages' do
        expect(assigns(:event).errors.full_messages).to eq(err_messages)
      end
    end
  end

  context '#edit' do
    let(:event) { current_user.events.first }
    before { get :edit, params: {id: current_user.events.first} }

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
    let(:event) { current_user.events.first }
    let(:staff_relation) { create(:staff_relation) }
    let(:event_attrs) { { name: 'Name', description: 'Редактирование описания' } }

    context 'when successful' do
      before do
        put :update, params: {id: event, event: event_attrs, staff_relation: staff_relation.id, format: :js}
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
        put :update, params: {id: event, event: (attributes_for :invalid_event), staff_relation: staff_relation.id, format: :json}
      end

      it 'renders "edit" template' do
        expect(assigns(:event).errors.full_messages).to eq(err_messages)
      end
    end
  end

  context '#destroy' do
    let(:event) { current_user.events.first }
    let(:id) { event.id }
    before do
      delete :destroy, params: {id: event}
    end

    it 'destroys event' do
      expect(Event.pluck(:id)).not_to include(id)
    end

    it 'redirects to events index page' do
      expect(response).to redirect_to(events_path)
    end
  end
end

