require 'rails_helper'

RSpec.describe StickersController, type: :controller do
  context '#index' do
    before(:each) do
      get :index
    end

    let(:stickers_list) { create_list(:sticker, 3) }

    it 'has successfull response' do
      expect(response).to be_success
    end

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'assigns all stickers with @stickers variable' do
      expect(assigns(:stickers)).to match_array(stickers_list)
    end
  end

  context '#new' do
    before(:each) do
      get :new
    end

    it 'has HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders "new" template' do
      expect(response).to render_template('new')
    end

    it 'creates instanse of Sticker class' do
      expect(assigns(:sticker)).to be_a_new(Sticker)
    end
  end

  context '#create' do
    context 'when successfull' do
      let(:sticker_params) { { sticker: { title: 'test title', description: 'some description' } } }

      it 'creates new Sticker object' do
        expect { post :create, sticker_params }.to change(Sticker, :count).by(1)
      end

      it 'redirects to stickers list page' do
        post :create, sticker: attributes_for(:sticker)
        expect(response).to redirect_to(stickers_path)
      end
    end

    context 'when failed' do
      let(:sticker_params) { { sticker: { title: nil, description: 'some description' } } }

      it 'doesnt create record on failing' do
        expect { post :create, sticker_params }.to change(Sticker, :count).by(0)
      end

      it 'render "new" template on failing' do
        post :create, sticker_params
        expect(response).to render_template('new')
      end
    end
  end

  context '#update' do
    let(:sticker) { create(:sticker) }

    before(:each) do
      get :edit, id: sticker.id
    end

    it 'reponds with HTTP status 200' do
      expect(response).to have_http_status(200)
    end

    it 'render "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#update' do
    let(:sticker_attrs) { attributes_for :sticker }

    before(:each) do
      @sticker = create(:sticker)

      put :update, id: @sticker.id, sticker: sticker_attrs
      @sticker.reload
    end

    context 'when successfull' do
      it 'redirects to stickers list page' do
        expect(response).to redirect_to(stickers_path)
      end

      it 'has updated title and description' do
       expect(@sticker.title).to eql sticker_attrs[:title]
       expect(@sticker.description).to eql sticker_attrs[:description]
      end

      it 'responds successfully with HTTP 200 status code' do
       put :edit, id: @sticker.id, sticker: sticker_attrs
       expect(response).to be_success
       expect(response).to have_http_status(200)
      end
    end

    context 'when failed' do
      it 'should render "edit" template on failing' do
        put :update, id: @sticker.id, sticker: (attributes_for :invalid_sticker)
        expect(response).to render_template('edit')
      end
    end
  end

  context '#destroy' do
    before do
      @sticker = create(:sticker)
    end
    it 'destroys sticker' do
      expect{
        delete :destroy, id: @sticker.id
      }.to change(Sticker, :count).by(-1)
    end

    it 'redirects to stickers list page' do
      delete :destroy, id: @sticker.id
      expect(response).to redirect_to(stickers_path)
    end
  end

end