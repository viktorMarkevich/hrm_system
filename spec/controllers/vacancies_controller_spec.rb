require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do

  before(:each) do
    user = create(:user)
    sign_in user
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
    context 'when successfull' do
      let(:vacancy_params) { { vacancy: attributes_for(:vacancy) } }

      it 'creates new Vacancy object' do
        expect { post :create, vacancy_params }.to change(Vacancy, :count).by(1)
      end

      it 'redirects to vacancies list page' do
        post :create, vacancy_params
        expect(response).to redirect_to vacancies_path
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

      it 'has update name and salary' do
        expect(@vacancy.name).to eql vacancy_attrs[:name]
        expect(@vacancy.salary).to eql vacancy_attrs[:salary]
      end

      it 'redirect to vacancies list page' do
        expect(response).to redirect_to(vacancies_path)
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


