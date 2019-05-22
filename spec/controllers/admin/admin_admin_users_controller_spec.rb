require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do

  render_views

  let(:admin_user) { create(:admin_user) }
  before { sign_in admin_user }

  context '#index' do
    it 'has HTTP 200 status' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  context '#update' do
    let(:admin_user_attrs) { attributes_for :admin_user }

    before do
      put :update, params: { id: admin_user, admin_user: admin_user_attrs }
      admin_user.reload
    end

    context 'when successful' do
      it 'redirects to user page' do
        expect(response).to redirect_to(admin_admin_user_path(admin_user))
      end

      it 'has updated email' do
        expect(admin_user.email).to eql admin_user_attrs[:email]
      end

      it 'has HTTP 200 status' do
        put :edit, params: { id: admin_user, admin_user: admin_user_attrs }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      context 'when failed' do
        it 'redirects to admin user show page' do
          put :update, params: { id: admin_user, admin_user: (attributes_for :invalid_user) }
          expect(response).to redirect_to(admin_admin_user_path(admin_user))
        end
      end
    end
  end

  context '#destroy' do
    it 'redirects to admin users index page' do
      delete :destroy, params: { id: admin_user }
      expect(response).to redirect_to(admin_admin_users_path)
    end
  end

end