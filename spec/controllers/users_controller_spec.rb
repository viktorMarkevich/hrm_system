require 'rails_helper'

describe UsersController, type: :controller do

  let!(:user) { create :user }

  before(:each) do
    sign_in user
  end

  describe 'check edit action' do

    before(:each) do
      get :show, id: user
    end

    context '#show' do
      it 'reponds with HTTP status 200' do
        expect(response).to have_http_status(200)
      end

      it 'render "edit" template' do
        expect(response).to render_template('show')
      end
    end
  end

  describe 'check edit action' do

    before(:each) do
      get :edit, id: user
    end

    context '#edit' do
      it 'reponds with HTTP status 200' do
        expect(response).to have_http_status(200)
      end

      it 'render "edit" template' do
        expect(response).to render_template('edit')
      end
    end
  end


  describe 'check update action' do
    let(:user_attrs) { attributes_for :user }
    let(:region) { create :region }

    before(:each) do
      put :update, id: user, user: user_attrs
      user.reload
    end

    context 'when successfully' do
      it 'redirects to user page' do
        expect(response).to redirect_to(user_path(user))
      end

      it 'has updated email and skype' do
        expect(user.email).to eql user_attrs[:email]
        expect(user.skype).to eql user_attrs[:skype]
      end

      it 'has updated region_id' do
        put :update, id: user, user: { region_id: region.id }
        expect(assigns(:user).region_id).to eq(region.id)
      end
    end

    context 'when failed' do
      it 'should render "edit" template on failing' do
        put :update, id: user, user: (attributes_for :invalid_user)
        expect(response).to render_template('edit')
      end
    end
  end
end
