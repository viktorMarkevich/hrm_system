require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do

  let(:user) { create :user }
  let(:company) { create :company }

  before { sign_in user }

  context '#index' do
    before { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'has companies list with only created company' do
      expect(assigns(:companies)).to eq([company])
    end
  end

  context '#create' do
    context 'when successful' do
      let(:company_attrs) { { params: { company: attributes_for(:company) } } }

      before { post :create, company_attrs }

      it 'creates new Company object' do
        expect(Company.count).to eq(1)
        expect(Region::REGIONS.include?(assigns(:company).region)).to eq true
      end

      it 'redirects to companies index page' do
       expect(response).to redirect_to companies_path
      end
    end

    context 'when failed' do
      let(:company_attrs) { { company: attributes_for(:company, region: nil) } }

      it 'invalid without region' do
        expect(build(:company, region: nil, name: nil)).to_not be_valid
      end

      it %q{ doesn't create record without region } do
        expect{ post :create, params: company_attrs }.to change(Company, :count).by(0)
      end

      it 'renders "new" template' do
        post :create, params: company_attrs
        expect(response).to render_template('new')
      end
    end
  end

  context '#new' do
    before { get :new }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "new" template' do
      expect(response).to render_template('new')
    end

    it 'creates Company class instance' do
      expect(assigns(:company)).to be_a_new(Company)
    end
  end

  context '#edit' do
    before { get :edit, params: { id: company } }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    before { get :show, params: { id: company } }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "show" template' do
      expect(response).to render_template('show')
    end
  end

  context '#update' do
    context 'when successful' do
      let(:company_attrs) { { name: 'facebook', url: 'http://www.facebook.com.ua', region: 'Одесса' } }

      before do
        put :update, params: { id: company, company: company_attrs }
        company.reload
      end

      it 'has updated name and url' do
        expect(company.name).to eql 'facebook'
        expect(company.region).to eql 'Одесса'
        expect(company.url).to eql company_attrs[:url]
      end

      it 'redirects to company show page' do
        expect(response).to redirect_to company_path(company)
      end
    end

    context 'when failed' do
      it 'renders "edit" template without name' do
        put :update, params: { id: company, company: { name: nil, region: nil } }
        expect(response).to render_template('edit')
      end
    end
  end

end