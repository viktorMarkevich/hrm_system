require 'rails_helper'

describe UsersController, type: :controller do

  let(:user) { create :user }

  before { sign_in user }

  context '#index' do
    before { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'has users list with only current user' do
      expect(assigns(:users)).to eq([user])
    end
  end

  context '#edit' do
    before { get :edit, id: user }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    before { get :show, id: user }

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

    context 'when successful' do
      context 'updates the same attributes' do
        before do
          put :update, id: user, user: user_attrs
          user.reload
        end

        it 'redirects to user show page' do
          expect(response).to redirect_to(user_path(user))
        end

        it 'has updated email and skype' do
          expect(user.email).to eql user_attrs[:email]
          expect(user.skype).to eql user_attrs[:skype]
        end
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