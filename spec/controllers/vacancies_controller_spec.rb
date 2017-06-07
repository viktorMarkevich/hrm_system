require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do

  let(:user) { create(:user) }
  let(:vacancy) { create(:vacancy) }

  before { sign_in user }

  def err_messages
    ["Имя не может быть пустым"]
  end

  context '#index' do
    before { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'has vacancies list with only created vacancy' do
      expect(assigns(:vacancies)).to eq([vacancy])
    end
  end

  describe '#create' do
    context 'when successful' do

      let(:vacancy_attrs) { { params: { vacancy: attributes_for(:vacancy) } } }

      before do
        post :create, vacancy_attrs
      end

      it 'creates new Vacancy object' do
        expect(Vacancy.count).to eq(1)
      end

      it 'redirects to vacancies index page' do
        expect(response).to redirect_to vacancies_path
      end

      it 'has assigned region and owner' do
        expect(assigns(:vacancy).owner.last_name).to eq(user.last_name)
      end
    end

    context 'when failed' do
      let(:invalid_vacancy_attrs) { { vacancy: attributes_for(:invalid_vacancy)} }

      before do
        post :create, params: invalid_vacancy_attrs
      end

      it %q{ doesn't create record } do
        expect { Vacancy.count }.to change(Vacancy, :count).by(0)
      end

      it 'renders "new" template' do
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

    it 'creates Vacancy class instance' do
      expect(assigns(:vacancy)).to be_a_new(Vacancy)
    end
  end

  context '#edit' do
    before do
      get :edit, params: {id: vacancy}
    end

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    before { get :show, params: {id: vacancy} }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "show" template' do
      expect(response).to render_template('show')
    end
  end

  describe '#update' do
    let(:region) { Region::REGIONS.sample }
    let(:vacancy_attrs) { { name: 'Менеджер', salary: '400', region: region } }

    before do
      put :update, params: {id: vacancy, vacancy: vacancy_attrs }
      vacancy.reload
    end

    context 'when successful' do
      it 'has updated name, salary and status' do
        expect(vacancy.name).to eql vacancy_attrs[:name]
        expect(vacancy.salary).to eql vacancy_attrs[:salary]
        expect(vacancy.region).to eql region
      end

      it 'redirect to vacancies index page' do
        expect(response).to redirect_to(vacancy_path(vacancy))
      end
    end

    context 'when failed' do
      before do
        put :update, params: {id: vacancy, vacancy: { name: nil }}
      end

      it 'renders "edit" template without name' do
        expect(response).to render_template('edit')
      end

      it 'error messages' do
        expect(assigns(:vacancy).errors.full_messages).to eq(err_messages)
      end
    end
  end

  describe '#destroy' do

    before do
      delete :destroy, params: {id: vacancy}
    end

    it 'destroys vacancy' do
      expect(Vacancy.pluck(:id)).not_to include(vacancy.id)
    end

    it 'redirects to vacancy index page' do
      expect(response).to redirect_to(vacancies_path)
    end
  end
end