require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do

  before(:each) do
    user = create(:user)
    sign_in user
  end

  context '#index' do
    let(:company) { create(:company)}

    before(:each) do
      get :index
    end

    it 'responds with HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "index"' do
      expect(response).to render_template('index')
    end
  end

  context '#show' do
    let(:company) { create(:company)}

    before(:each) do
      get :show, id: company.id
    end

    it 'responds with HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "show"' do
      expect(response).to render_template('show')
    end
  end

  context '#edit' do
    let(:company) { create(:company) }

    before(:each) do
      get :edit, id: company.id
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "edit"' do
      expect(response).to render_template('edit')
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

    it 'creates an instance of Company class' do
      expect(assigns(:company)).to be_a_new(Company)
    end
  end

  context '#create' do
    before(:each) do
      @region = create(:region, name: 'Запорожье')
    end

    context 'when successfull' do
      let(:company_attrs) { { company: attributes_for(:company), region: @region.name } }

      it 'creates new Company object' do
        expect { post :create, company_attrs }.to change(Company, :count).by(1)
      end

      it 'redirects to companies list page' do
        post :create, company_attrs
        expect(response).to redirect_to companies_path
      end

      it 'has assigned region' do
        post :create, company_attrs
        expect(assigns(:company).region.name).to eq(@region.name)
      end
    end

    context 'when failed' do
      let(:company_attrs) { { company: attributes_for(:company, region_id: nil) } }

      it 'is invalid without region_id' do
        expect(build(:company, region_id: nil)).to_not be_valid
      end

      it 'is invalid without name' do
        expect(build(:company, name: nil)).to_not be_valid
      end

      it %q{ doesn't create without region_id } do
        expect{ post :create, company_attrs }.to change(Company, :count).by(0)
      end

      it 'renders "new" template on failing' do
        post :create, company_attrs
        expect(response).to render_template('new')
      end
    end
  end

  context '#update' do
    before(:each) do
      @company = create(:company)
    end

    context 'when successfull' do
      let(:company_attrs) { { name: 'facebook', url: 'http://www.facebook.com.ua' } }

      before(:each) do
        put :update, id: @company.id, company: company_attrs
        @company.reload
      end

      it 'has update name and url' do
        expect(@company.name).to eql company_attrs[:name]
        expect(@company.url).to eql company_attrs[:url]
      end

      it 'redirect to show page' do
        expect(response).to redirect_to company_path(@company)
      end
    end

    context 'when failed' do
      it 'renders "edit" template without name' do
        put :update, id: @company.id, company: { name: nil }
        expect(response).to render_template('edit')
      end

      it 'renders "edit" template without region_id' do
        put :update, id: @company.id, company: { region_id: nil }
        expect(response).to render_template('edit')
      end
    end

  end
end