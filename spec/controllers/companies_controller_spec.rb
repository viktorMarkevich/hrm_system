require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do

  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let(:region) { create(:region) }

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
      let(:company_attrs) { { company: attributes_for(:company), region: region.name } }

      before { post :create, company_attrs }

      it 'creates new Company object' do
        expect(Company.count).to eq(1)
      end

      it 'redirects to companies index page' do
        expect(response).to redirect_to companies_path
      end

      it 'has assigned region' do
        expect(assigns(:company).region.name).to eq(region.name)
      end
    end

    context 'when failed' do
      let(:company_attrs) { { company: attributes_for(:company, region_id: nil) } }

      it 'invalid without region_id' do
        expect(build(:company, region_id: nil)).to_not be_valid
      end

      it 'invalid without name' do
        expect(build(:company, name: nil)).to_not be_valid
      end

      it %q{ doesn't create record without region_id } do
        expect{ post :create, company_attrs }.to change(Company, :count).by(0)
      end

      it 'renders "new" template' do
        post :create, company_attrs
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
    before { get :edit, id: company }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    before { get :show, id: company }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "show" template' do
      expect(response).to render_template('show')
    end
  end

  context '#update' do
    context 'when successful' do
      let(:company_attrs) { { name: 'facebook', url: 'http://www.facebook.com.ua' } }

      before do
        put :update, id: company, company: company_attrs, region: region.name
        company.reload
      end

      it 'has updated name and url' do
        expect(company.name).to eql company_attrs[:name]
        expect(company.url).to eql company_attrs[:url]
      end

      it 'redirects to company show page' do
        expect(response).to redirect_to company_path(company)
      end
    end

    context 'when failed' do
      it 'renders "edit" template without name' do
        put :update, id: company, company: { name: nil }
        expect(response).to render_template('edit')
      end

      it 'renders "edit" template without region_id' do
        put :update, id: company, company: { region_id: nil }
        expect(response).to render_template('edit')
      end
    end
  end
end