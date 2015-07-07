require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do

  before(:each) do
    user = create(:user)

    sign_in user
  end

  context '#index' do
    before(:each) { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end
  end

  context '#create' do
    before(:each) do
      @user = create(:user)
      @region = create(:region, name: 'Запорожье')
    end

    context 'when successful' do
      before(:each) { post :create, vacancy_attrs }

      let(:vacancy_attrs) { { vacancy: attributes_for(:vacancy), region: @region.name } }

      it 'creates new Vacancy object' do
        expect(Vacancy.count).to eq(1)
      end

      it 'redirects to vacancies list page' do
        expect(response).to redirect_to vacancies_path
      end

      it 'has assigned region and owner' do
        expect(assigns(:vacancy).region.name).to eq(@region.name)
        expect(assigns(:vacancy).owner.last_name).to eq(@user.last_name)
      end
    end

    context 'when failed' do
      let(:vacancy_attrs) { { vacancy: attributes_for(:vacancy, region_id: nil) } }

      it 'is invalid without region_id' do
        expect(build(:vacancy, region_id: nil)).to_not be_valid
      end

      it 'is invalid without name' do
        expect(build(:vacancy, name: nil)).to_not be_valid
      end

      it 'is invalid without status' do
        expect(build(:vacancy, status: nil)).to_not be_valid
      end

      it %q{ doesn't create record } do
        expect { post :create, vacancy_attrs }.to change(Vacancy, :count).by(0)
      end

      it 'renders "new" template on failing' do
        post :create, vacancy_attrs
        expect(response).to render_template('new')
      end
    end
  end

  context '#new' do
    before(:each) { get :new }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "new" template' do
      expect(response).to render_template('new')
    end

    it 'creates Vacancy class instance' do
      expect(assigns(:vacancy)).to be_a_new(Vacancy)
    end
  end

  context '#edit' do
    let(:vacancy) { create(:vacancy) }

    before(:each) do
      get :edit, id: vacancy
    end

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    let(:vacancy) { create(:vacancy)}

    before(:each) { get :show, id: vacancy }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "show" template' do
      expect(response).to render_template('show')
    end
  end

  context '#update' do
    let(:vacancy_attrs) { { name: 'Менеджер', salary: '400' } }

    before(:each) do
      @vacancy = create(:vacancy)
      put :update, id: @vacancy, vacancy: vacancy_attrs, region: 'Запорожье'
      @vacancy.reload
    end

    context 'when successful' do
      it 'has updated name and salary' do
        expect(@vacancy.name).to eql vacancy_attrs[:name]
        expect(@vacancy.salary).to eql vacancy_attrs[:salary]
      end

      it 'redirect to vacancies_path' do
        expect(response).to redirect_to(vacancies_path)
      end
    end

    context 'when failed' do
      it 'renders "edit" template without name' do
        put :update, id: @vacancy, vacancy: { name: nil }
        expect(response).to render_template('edit')
      end

      it 'renders "edit" without status' do
        put :update, id: @vacancy, vacancy: { status: nil }
        expect(response).to render_template('edit')
      end
    end
  end
end