require 'rails_helper'

describe UsersController, type: :controller do

  let!(:user) { create :user }

  before(:each) { sign_in user }

  context '#index' do
    before(:each) { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'matches created users count' do
      users_list = create_list(:user, 3)
      expect(assigns(:users).size).to eq(users_list.size + 1)
    end
  end

  context '#edit' do
    before(:each) { get :edit, id: user }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    before(:each) { get :show, id: user }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "show" template' do
      expect(response).to render_template('show')
    end
  end

  context '#update' do
    let(:user_attrs) { attributes_for :user }
    let(:region) { create :region }

    context 'check validations' do
      context 'when successful' do
        it 'redirects to user_path' do
          put :update, id: user, user: user_attrs
          user.reload
          expect(response).to redirect_to(user_path(user))
        end

        it 'has updated email and skype' do
          put :update, id: user, user: user_attrs
          user.reload
          expect(user.email).to eql user_attrs[:email]
          expect(user.skype).to eql user_attrs[:skype]
        end

        it 'has updated region_id' do
          put :update, id: user, user: { region_id: region.id }
          user.reload
          expect(assigns(:user).region_id).to eq(region.id)
        end
      end

      context 'when failed' do
        it 'renders "edit" template' do
          put :update, id: user, user: (attributes_for :invalid_user)
          expect(response).to render_template('edit')
        end
      end
    end
  end
end
