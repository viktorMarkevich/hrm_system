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

    it 'renders template "show"' do
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
    context 'when successfull' do
      let(:company_params) { { company: attributes_for(:company) } }

      it 'creates new Company object' do
        expect { post :create, company_params }.to change(Company, :count).by(1)
      end

      it 'redirects to companies list page' do
        post :create, company_params
        expect(response).to redirect_to companies_path
      end
    end
  end

  context '#update' do
    let(:company_attrs) { { name: 'facebook', url: 'http://www.facebook.com.ua' } }

    before(:each) do
      @company = create(:company)

      put :update, id: @company.id, company: company_attrs
      @company.reload
    end

    context 'when successfull' do

      it 'has update name and url' do
        expect(@company.name).to eql company_attrs[:name]
        expect(@company.url).to eql company_attrs[:url]
      end

      it 'redirect to show page' do
        expect(response).to redirect_to company_path(@company)
      end
    end
  end
end