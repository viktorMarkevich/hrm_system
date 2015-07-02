require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do

  before(:each) do
    user = create(:user)
    sign_in user
  end

  context '#index' do
    before(:each) do
      get :index
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "index"' do
      expect(response).to render_template('index')
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

    it 'creates an instance of Vacancy class' do
      expect(assigns(:vacancy)).to be_a_new(Vacancy)
    end
  end

  context '#create' do
    before(:each) do
      @region = create(:region, name: 'Запорожье')
    end

    context 'when successfull' do
      let(:vacancy_attrs) { { vacancy: attributes_for(:vacancy), region: @region.name } }

      it 'creates new Vacancy object' do
        expect { post :create, vacancy_attrs }.to change(Vacancy, :count).by(1)
      end

      it 'redirects to vacancies list page' do
        post :create, vacancy_attrs
        expect(response).to redirect_to vacancies_path
      end

      it 'has assigned region' do
        post :create, vacancy_attrs
        expect(assigns(:vacancy).region.name).to eq(@region.name)
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

  context '#edit' do
    let(:vacancy) { create(:vacancy) }

    before(:each) do
      get :edit, id: vacancy.id
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "edit"' do
      expect(response).to render_template('edit')
    end
  end

  context '#update' do
    let(:vacancy_attrs) { { name: 'Менеджер', salary: '400' } }

    before(:each) do
      @vacancy = create(:vacancy)

      put :update, id: @vacancy.id, vacancy: vacancy_attrs
      @vacancy.reload
    end

    context 'when successfull' do
      it 'has updated name and salary' do
        expect(@vacancy.name).to eql vacancy_attrs[:name]
        expect(@vacancy.salary).to eql vacancy_attrs[:salary]
      end

      it 'redirect to vacancies list page' do
        expect(response).to redirect_to(vacancies_path)
      end
    end

    context 'when failed' do
      it 'renders "edit" template without name' do
        put :update, id: @vacancy.id, vacancy: { name: nil }
        expect(response).to render_template('edit')
      end

      it 'renders "edit" template without region_id' do
        put :update, id: @vacancy.id, vacancy: { region_id: nil }
        expect(response).to render_template('edit')
      end

      it 'renders "edit" without status' do
        put :update, id: @vacancy.id, vacancy: { status: nil }
        expect(response).to render_template('edit')
      end
    end

  end

  context '#show' do
    let(:vacancy) { create(:vacancy)}

    before(:each) do
      get :show, id: vacancy.id
    end

    it 'responds with HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "show"' do
      expect(response).to render_template('show')
    end
  end

end


