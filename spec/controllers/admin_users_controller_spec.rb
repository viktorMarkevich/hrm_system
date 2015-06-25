require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  before(:each) do
    @admin_user = create(:admin_user)
    sign_in @admin_user
    @user = create(:user)
  end

  context '#index' do
    let(:user) { create(:user) }

    before(:each) do
      get :index
    end

    it 'reponds with HTTP status 200' do
      expect(response).to have_http_status(200)
    end
  end

  context '#new_invitation' do
    let(:user) { create(:user) }

    before(:each) do
      get :new_invitation
    end

    it 'reponds with HTTP status 200' do
      expect(response).to have_http_status(200)
    end
  end

  context '#update' do
    let(:user_attrs) { attributes_for :user }

    before(:each) do
      put :update, id: @user.id, user: user_attrs
      @user.reload
    end

    context 'when successfull' do
      it 'redirects to user page' do
        expect(response).to redirect_to(admin_user_path(@user))
      end

      it 'has updated email' do
        expect(@user.email).to eql user_attrs[:email]
      end

      it 'responds successfully with HTTP 200 status code' do
        put :edit, id: @user.id, user: user_attrs
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    context 'when failed' do
      it 'should redirect after failing' do
        put :update, id: @user.id, user: (attributes_for :invalid_user)
        expect(response).to redirect_to(admin_user_path(@user))
      end
    end
  end

  context '#destroy' do
    it 'renders after #destroy' do
      delete :destroy, id: @user.id
      expect(response).to redirect_to(admin_users_path)
    end
  end

end