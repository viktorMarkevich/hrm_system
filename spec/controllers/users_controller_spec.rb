require 'rails_helper'

describe UsersController, type: :controller do

  before(:each) do
    @user = create(:user)
    sign_in @user
  end

  context '#show' do
    let(:user) { create(:user) }

    before(:each) do
      get :show, id: user.id
    end

    it 'responds with HTTP status 200' do
      expect(response).to have_http_status(200)
    end

    it 'render "edit" template' do
      expect(response).to render_template('show')
    end
  end

  context '#edit' do
    let(:user) { create(:user) }

    before(:each) do
      get :edit, id: user.id
    end

    it 'responds with HTTP status 200' do
      expect(response).to have_http_status(200)
    end

    it 'render "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#update' do

    before(:each) do
      @region = create(:region, name: 'Запорожье')
      @user_attrs = attributes_for(:user)
    end

    context 'when successfull' do
      before(:each) do
        @user_attrs = attributes_for :user
        put :update, id: @user.id, user: @user_attrs
        @user.reload
      end

      it 'redirects to user page' do
        expect(response).to redirect_to(user_path(@user))
      end

      it 'has updated email and skype' do
        expect(@user.email).to eql @user_attrs[:email]
        expect(@user.skype).to eql @user_attrs[:skype]
      end

      it 'responds successfully with HTTP 200 status code' do
        put :edit, id: @user.id, user: @user_attrs
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'has updated region_id' do
        put :update, id: @user.id, user: { region_id: 555 }
        expect(assigns(:user).region_id).to eq(555)
      end
    end

    context 'when failed' do
      it 'should render "edit" template on failing' do
        put :update, id: @user.id, user: (attributes_for :invalid_user)
        expect(response).to render_template('edit')
      end
    end

  end

end
