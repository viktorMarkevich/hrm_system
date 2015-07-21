require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  let(:user) { create(:user) }
  let(:event) { create(:event) }

  before { sign_in user }

  context '#index' do
    before { get :index  }

    it 'has successful response' do
      expect(response).to be_success
    end

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'assigns all events as @events' do
      get :index
      expect(assigns(:events)).to eq([event])
    end
  end

  context '#create' do
    context 'when successful' do
      let(:event_params) { { event: { name: 'Name', starts_at: '2015-10-15 09:12:00', description: 'Описание' } } }

      before { post :create, event_params }

      it 'creates new Event object' do
        expect(Event.count).to eq(1)
      end

      it 'redirects to the created event' do
        expect(response).to redirect_to(Event.last)
      end
    end

    context 'when failed' do
      let(:event_params) { { event: { name: nil, starts_at: '2011-12-11 12:11:12', description: nil } } }

      before { post :create, event_params }

      it %q{ doesn't create new record } do
        expect(Event.count).to eq(0)
      end

      it 'renders "new" template' do
        expect(response).to render_template('new')
      end
    end
  end

  context '#new' do
    before { get :new }

    it 'has HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders "new" template' do
      expect(response).to render_template('new')
    end

    it 'creates an instance of Event class' do
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  context '#edit' do
    before { get :edit, id: event }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#update' do
    let(:event_attrs) { { name: 'Name', description: 'Редактирование описания' } }

    context 'when successful' do
      before do
        put :update, id: event, event: event_attrs
        event.reload
      end

      it 'has updated name' do
        expect(event.name).to eql event_attrs[:name]
      end

      it 'redirects to events index page' do
        expect(response).to redirect_to(event)
      end
    end

    context 'when failed' do
      it 'renders "edit" template' do
        put :update, id: event, event: (attributes_for :invalid_event)
        expect(response).to render_template('edit')
      end
    end
  end

  context '#destroy' do
    let(:event) { create(:event) }

    it 'destroys event' do
      delete :destroy, id: event
      expect(Event.count).to eq 0
    end

    it 'redirects to events index page' do
      delete :destroy, id: event
      expect(response).to redirect_to(events_path)
    end
  end
end
