require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  let(:admin_user) { create(:admin_user) }
  let(:user) { create(:user) }

  before { sign_in admin_user }

  context '#index' do
    it 'has HTTP 200 status' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  context '#new' do
    let(:user_attrs) { { user: { params: { email: 'aaa@aaa.aaa', first_name: 'Roman', last_name: 'Liskov', post: 'Директор', region: 'region' } } } }

    context 'when successful' do
      it 'redirects to admin user page' do
        post :send_invitation, params: user_attrs
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'when failed' do
      it 'redirects to index admin user page' do
        create(:user, email: 'aaa@aaa.aaa')
        post :send_invitation, params: user_attrs
        expect(response).to redirect_to(admin_users_path)
      end
    end
  end

  context '#update' do
    let(:user_attrs) { { email: 'aaa@aaa.aaa', first_name: 'Roman', last_name: 'Liskov', post: 'Директор', region: 'region' } }

    before do
      put :update, params: { id: user, user: user_attrs }
      user.reload
    end

    context 'when successful' do
      it 'redirects to admin user page' do
        expect(response).to redirect_to(admin_user_path(user))
      end

      it 'has updated email' do
        expect(user.email).to eql user_attrs[:email]
      end

      it 'has updated region' do
        expect(user.region).to eql 'region'
      end

      it 'has HTTP 200 status' do
        put :edit, params: {id: user, user: user_attrs}
        expect(response).to have_http_status(200)
      end
    end

    context 'when failed' do
      it 'renders "edit" template' do
        put :update, params: {id: user, user: (attributes_for :invalid_user)}
        expect(response).to render_template('edit')
      end
    end
  end

  context '#destroy' do
    it 'redirects to admin users index page' do
      delete :destroy, params: {id: user}
      expect(response).to redirect_to(admin_users_path)
    end
  end

  context 'send invitation' do
    it 'sends an email' do
      expect{ user.deliver_invitation }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
