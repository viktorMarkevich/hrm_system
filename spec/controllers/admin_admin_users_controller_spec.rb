require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do
  render_views

  before(:each) do
    @admin_user = create(:admin_user)
    sign_in @admin_user
  end

  context '#index' do
    before(:each) { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end
  end

  context '#update' do
    let(:admin_user_attrs) { attributes_for :admin_user }

    before(:each) do
      put :update, id: @admin_user, admin_user: admin_user_attrs
      @admin_user.reload
    end

    context 'when successful' do
      it 'redirects to user page' do
        expect(response).to redirect_to(admin_admin_user_path(@admin_user))
      end

      it 'has updated email' do
        expect(@admin_user.email).to eql admin_user_attrs[:email]
      end

      it 'has HTTP 200 status' do
        put :edit, id: @admin_user, admin_user: admin_user_attrs
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      context 'when failed' do
        it 'redirects to admin_admin_user_path ' do
          put :update, id: @admin_user, admin_user: (attributes_for :invalid_user)
          expect(response).to redirect_to(admin_admin_user_path(@admin_user))
        end
      end
    end
  end

  context '#destroy' do
    it 'redirects to admin_admin_users_path' do
      delete :destroy, id: @admin_user
      expect(response).to redirect_to(admin_admin_users_path)
    end
  end
end
