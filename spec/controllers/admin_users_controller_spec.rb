require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  before(:each) do
    @admin_user = create(:admin_user)
    @user = create(:user)

    sign_in @admin_user
  end

  context '#index' do
    before(:each) { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

  end

  context '#update' do
    let(:user_attrs) { attributes_for :user}

    before(:each) do
      put :update, id: @user, user: user_attrs, region: 'Запорожье'
      @user.reload
    end

    context 'check validations' do
      context 'when successful' do
        it 'redirects to user page' do
          expect(response).to redirect_to(admin_user_path(@user))
        end

        it 'has updated email' do
          expect(@user.email).to eql user_attrs[:email]
        end

        it 'has updated region' do
          expect(@user.region.name).to eql 'Запорожье'
        end

        it 'has HTTP 200 status' do
          put :edit, id: @user.id, user: user_attrs
          expect(response).to have_http_status(200)
        end
      end

      context 'when failed' do
        it 'renders "edit" template' do
          put :update, id: @user.id, user: (attributes_for :invalid_user)
          expect(response).to render_template('edit')
        end
      end
    end
  end

  context '#destroy' do
    it 'renders after #destroy' do
      delete :destroy, id: @user.id
      expect(response).to redirect_to(admin_users_path)
    end
  end

  context 'send invitation' do
    it 'sends an email' do
      expect{ @user.deliver_invitation }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
