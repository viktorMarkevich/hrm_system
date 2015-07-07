require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  before do
    user = create(:user)

    sign_in user
  end

  let(:candidate) { create(:candidate) }

  context '#index' do
    let(:candidates_list) { create_list(:candidate, 3) }

    before { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'matches candidates_list' do
      expect(assigns(:candidates)).to match_array(candidates_list)
    end
  end

  context '#create' do
    context 'when successful' do
      before { post :create, candidate: attributes_for(:candidate) }

      it 'creates new Candidate object' do
        expect(assigns(:candidate)).to eq(Candidate.last)
      end

      it 'redirects to candidates list page' do
        expect(response).to redirect_to candidates_path
      end
    end

    context 'when failed' do
      it 'renders "new" template' do
        post :create, candidate: attributes_for(:candidate, status: nil)
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

    it 'creates Candidate class instance' do
      expect(assigns(:candidate)).to be_a_new(Candidate)
    end

  end

  context '#edit' do
    before { get :edit, id: candidate }

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    before { get :show, id: candidate }

    it 'responds with HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "show"' do
      expect(response).to render_template('show')
    end
  end

  context '#update' do
    context 'when successful' do
      let(:candidate_attrs) { { name: 'Rick Grimes', salary: '500' } }

      before do
        put :update, id: candidate, candidate: candidate_attrs
        candidate.reload
      end

      it 'has updated name and salary' do
        expect(candidate.name).to eql candidate_attrs[:name]
        expect(candidate.salary).to eql candidate_attrs[:salary]
      end

      it 'redirect to candidates list page' do
        expect(response).to redirect_to(candidates_path)
      end
    end

    context 'when failed' do
      it 'renders "edit" template' do
        put :update, id: candidate,  candidate: { status: nil }
        candidate.reload

        expect(response).to render_template('edit')
      end
    end

  end
end