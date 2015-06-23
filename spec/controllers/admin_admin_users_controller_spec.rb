require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do
  render_views

  before(:each) do
    @admin_user = create(:admin_user)
    sign_in @admin_user
    @user = create(:user)
  end

  context '#index' do
    let(:admin_user) { create(:admin_user) }

    before(:each) do
      get :index
    end

    it 'reponds with HTTP status 200' do
      expect(response).to have_http_status(200)
    end
  end

  context '#update' do
    let(:admin_user_attrs) { attributes_for :admin_user }

    before(:each) do
      put :update, id: @admin_user.id, admin_user: admin_user_attrs
      @admin_user.reload
    end

    context 'when successfull' do
      it 'redirects to user page' do
        expect(response).to redirect_to(admin_admin_user_path(@admin_user))
      end

      it 'has updated email' do
        expect(@admin_user.email).to eql admin_user_attrs[:email]
      end

      it 'responds successfully with HTTP 200 status code' do
        put :edit, id: @admin_user.id, admin_user: admin_user_attrs
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    context 'when failed' do
      it 'should redirect after failing' do
        put :update, id: @admin_user.id, admin_user: (attributes_for :invalid_user)
        expect(response).to redirect_to(admin_admin_user_path(@admin_user))
      end
    end
  end

  context '#destroy' do
    it 'renders after #destroy' do
      delete :destroy, id: @admin_user.id
      expect(response).to redirect_to(admin_admin_users_path)
    end
  end

end
