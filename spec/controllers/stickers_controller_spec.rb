require 'rails_helper'

RSpec.describe StickersController, type: :controller do

  before do
    @user = create(:user)

    sign_in @user
  end

  context '#index' do
    before { get :index  }

    let(:stickers_list) { create_list(:sticker, 3) }

    it 'has successful response' do
      expect(response).to be_success
    end

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'matches stickers_list' do
      expect(assigns(:stickers)).to match_array(stickers_list)
    end
  end

  context '#create' do
    let(:performer)  { create(:user) }

    context 'when successful' do
      let(:sticker_params) { { sticker: { description: 'Default description', performer_id: performer } } }

      before { post :create, sticker_params }

      it 'has owner' do
        expect(assigns(:sticker).owner).to eq(@user)
      end

      it 'has performer' do
        expect(assigns(:sticker).performer).to eq(performer)
      end

      it 'creates new Sticker object' do
        expect(Sticker.count).to eq(1)
      end

      it 'redirects to stickers_path' do
        expect(response).to redirect_to(stickers_path)
      end
    end

    context 'when failed' do
      let(:sticker_params) { { sticker: { description: nil } } }

      before { post :create, sticker_params }

      it %q{ doesn't create new record } do
        expect(Sticker.count).to eq(0)
      end

      it 'renders "new" template' do
        expect(response).to render_template('new')
      end
    end
  end

  context '#new' do
    before { get :new }

    it 'has HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders "new" template' do
      expect(response).to render_template('new')
    end

    it 'creates an instance of Sticker class' do
      expect(assigns(:sticker)).to be_a_new(Sticker)
    end
  end

  context '#edit' do
    let(:sticker) { create(:sticker) }

    before { get :edit, id: sticker }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#update' do
    let(:sticker_attrs) { { description: 'updated description' } }

    before { @sticker = create(:sticker) }

    context 'when successful' do
      before do
        put :update, id: @sticker, sticker: sticker_attrs
        @sticker.reload
      end

      it 'redirects to stickers_path' do
        expect(response).to redirect_to(stickers_path)
      end

      it 'has updated description' do
        expect(@sticker.description).to eql sticker_attrs[:description]
      end
    end

    context 'when failed' do
      it 'renders "edit" template' do
        put :update, id: @sticker, sticker: (attributes_for :invalid_sticker)
        expect(response).to render_template('edit')
      end
    end
  end

  context '#destroy' do
    before { @sticker = create(:sticker) }

    it 'destroys sticker' do
      expect{
        delete :destroy, id: @sticker
      }.to change(Sticker, :count).by(-1)
    end

    it 'redirects to stickers_path' do
      delete :destroy, id: @sticker
      expect(response).to redirect_to(stickers_path)
    end
  end
end