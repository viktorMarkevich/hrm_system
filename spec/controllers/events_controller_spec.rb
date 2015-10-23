require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:current_user) { create(:user_with_events) }
  let!(:user) { create(:user_with_events, events_count: 2) }

  before do
     sign_in current_user
  end

  context '#index' do
    before { get :index  }

    it 'has successful response; has HTTP 200 status; renders "index" template' do
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('index')
    end

    it 'assigns all events as @events' do
      expect(assigns(:events)).to eq(current_user.events.order(will_begin_at: :asc))
      expect(assigns(:events).length).to eq 5
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
      let (:will_begin_at) { DateTime.now + 10.hours + 12.minutes }
      before { post :create, event: event_params.update(will_begin_at: will_begin_at), format: :js }

      it 'creates new Event object' do
        expect(assigns(:events).length).to eq(6)
        expect(assigns(:event).will_begin_at).to eq will_begin_at
        expect(assigns(:event).name).to eq 'Name'
      end
    end

    context 'when successful with "staff_relations"' do
      let(:staff_relation) { create(:staff_relation, status: 'Собеседование') }
      before { post :create, event: event_params.update(staff_relation: staff_relation.id), format: :js }

      it 'creates new Event object' do
        expect(assigns(:events).length).to eq(6)
        expect(assigns(:event).name).to eq staff_relation.status
      end
    end
  end

  #   context 'when failed' do
  #     let(:staff_relation) { create(:staff_relation) }
  #     let(:event_params) { { event: { name: nil, will_begin_at: '2011-12-11 12:11:12', description: nil }, staff_relation: staff_relation.id } }
  #
  #     before { post :create, event_params }
  #
  #     # it %q{ doesn't create new record } do
  #     #   expect(Event.count).to eq(0)
  #     # end
  #
  #     # it 'renders "new" template' do
  #     #   expect(response).to render_template('new')
  #     # end
  #   end
  # end
  #

  #
  # context '#edit' do
  #   before { get :edit, id: event }
  #
  #   # it 'has HTTP 200 status' do
  #   #   expect(response).to have_http_status(200)
  #   # end
  #   #
  #   # it 'renders "edit" template' do
  #   #   expect(response).to render_template('edit')
  #   # end
  # end
  #
  # context '#update' do
  #   let(:staff_relation) { create(:staff_relation) }
  #   let(:event_attrs) { { name: 'Name', description: 'Редактирование описания' } }
  #
  #   context 'when successful' do
  #     before do
  #       put :update, id: event, event: event_attrs, staff_relation: staff_relation.id
  #       event.reload
  #     end
  #
  #     # it 'has updated name' do
  #     #   expect(event.name).to eql event_attrs[:name]
  #     # end
  #     #
  #     # it 'redirects to events index page' do
  #     #   expect(response).to redirect_to(event)
  #     # end
  #   end
  #
  #   context 'when failed' do
  #     # it 'renders "edit" template' do
  #     #   put :update, id: event, event: (attributes_for :invalid_event), staff_relation: staff_relation.id
  #     #   expect(response).to render_template('edit')
  #     # end
  #   end
  # end
  #
  # context '#destroy' do
  #   let(:event) { user.events.first }
  #
  #   it 'destroys event' do
  #     delete :destroy, id: event
  #     expect(Event.count).to eq 4
  #   end
  #
  #   it 'redirects to events index page' do
  #     delete :destroy, id: event
  #     expect(response).to redirect_to(events_path)
  #   end
  # end
end
