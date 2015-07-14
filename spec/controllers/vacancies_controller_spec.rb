require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do

  let(:user) { create(:user) }
  let(:vacancy) { create(:vacancy) }
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

    it 'has vacancies list with only created vacancy' do
      expect(assigns(:vacancies)).to eq([vacancy])
    end
  end

  context '#create' do
    context 'when successful' do
      before { post :create, vacancy_attrs }

      let(:vacancy_attrs) { { vacancy: attributes_for(:vacancy), region: region.name } }

      it 'creates new Vacancy object' do
        expect(Vacancy.count).to eq(1)
      end

      it 'redirects to vacancies index page' do
        expect(response).to redirect_to vacancies_path
      end

      it 'has assigned region and owner' do
        expect(assigns(:vacancy).region.name).to eq(region.name)
        expect(assigns(:vacancy).owner.last_name).to eq(user.last_name)
      end
    end

    context 'when failed' do
      let(:wrong_vacancy_attrs) { { vacancy: attributes_for(:vacancy, status: nil)} }

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
        expect { post :create, wrong_vacancy_attrs }.to change(Vacancy, :count).by(0)
      end

      it 'renders "new" template' do
        post :create, wrong_vacancy_attrs
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
    before { get :show, id: vacancy }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "show" template' do
      expect(response).to render_template('show')
    end
  end

  context '#update' do
    let(:vacancy_attrs) { { name: 'Менеджер', salary: '400' } }

    before do
      put :update, id: vacancy, vacancy: vacancy_attrs, region: region.name
      vacancy.reload
    end

    context 'when successful' do
      it 'has updated name and salary' do
        expect(vacancy.name).to eql vacancy_attrs[:name]
        expect(vacancy.salary).to eql vacancy_attrs[:salary]
      end

      it 'redirect to vacancies index page' do
        expect(response).to redirect_to(vacancies_path)
      end
    end

    context 'when failed' do
      it 'renders "edit" template without name' do
        put :update, id: vacancy, vacancy: { name: nil }
        expect(response).to render_template('edit')
      end

      it 'renders "edit" without status' do
        put :update, id: vacancy, vacancy: { status: nil }
        expect(response).to render_template('edit')
      end
    end
  end

  context '#search_candidates_by_status' do
    let(:attrs) { { id: vacancy, status: 'Найденные' } }

    before do
      get :show, id: vacancy
      get 'search_candidates_by_status', attrs
    end

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'finds certain vacancy' do
      expect(assigns(:vacancy)).to eq(vacancy)
    end

    it 'matches candidates with status "Найденные"' do
      candidate_with_found_status = create_list(:staff_relation, 3, vacancy: vacancy)
      expect(assigns(:matched_candidates).pluck(:id)).to match_array(candidate_with_found_status.map(&:candidate_id))
    end
  end

  context '#change_candidate_status' do
    let(:staff_relation) { create(:staff_relation, status: 'Утвержден', vacancy: vacancy) }
    let(:attrs_for_update) { { id: vacancy, candidate_id:  staff_relation.candidate, status: 'Утвержден' } }

    before do
      get :show, id: vacancy
      staff_relation
    end

    context 'when successful' do
      context 'when status is not "Нейтральный"' do
        before { post 'change_candidate_status', attrs_for_update }

        it 'has HTTP 200 status' do
          expect(response).to have_http_status(200)
        end

        it 'JSON return status "ok"' do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['status']).to eq 'ok'
        end
      end

      context 'when status is "Нейтральный"' do
        let(:attrs) { { id: vacancy, candidate_id:  staff_relation.candidate, status: 'Нейтральный' } }

        it 'deletes staff_relation' do
          expect{ post 'change_candidate_status', attrs }.to change(StaffRelation, :count).by(-1)
        end

        it 'updates candidates status on "Пассивен"' do
          post 'change_candidate_status', attrs
          expect(staff_relation.candidate.status).to eq('Пассивен')
        end

        it 'JSON returns status "ok"' do
          post 'change_candidate_status', attrs
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['status']).to eq 'ok'
        end
      end
    end
  end

  context '#mark_candidate_as_found' do
    let(:candidates_list) { create_list(:candidate, 2) }
    let(:attrs) { { id: vacancy, candidates_ids: candidates_list.map(&:id) } }

    before do
      post 'mark_candidates_as_found', attrs
      candidates_list
    end

    it 'updates candidates status on "В работе"' do
      expect(assigns(:marked_as_found_candidates).pluck(:status).uniq).to eq ['В работе']
    end

    it 'creates staff_relations for each candidate' do
      expect{ post 'mark_candidates_as_found', attrs }.to change(StaffRelation, :count).by(candidates_list.size)
    end

  end

end