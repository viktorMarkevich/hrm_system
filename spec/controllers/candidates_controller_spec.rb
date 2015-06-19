require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do

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

    it 'creates an instance of Candidate class' do
      expect(assigns(:candidate)).to be_a_new(Candidate)
    end
  end

  context '#create' do
    context 'when successfull' do
      let(:candidate_params) { { candidate: attributes_for(:candidate) } }

      it 'creates new Candidate object' do
        expect { post :create, candidate_params }.to change(Candidate, :count).by(1)
      end

      it 'redirects to candidates list page' do
        post :create, candidate_params
        expect(response).to redirect_to candidates_path
      end
    end
  end

  context '#edit' do
    let(:candidate) { create(:candidate) }

    before(:each) do
      get :edit, id: candidate.id
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#update' do
    let(:candidate_attrs) { { name: 'Rick Grimes', salary: '500' } }

    before(:each) do
      @candidate = create(:candidate)

      put :update, id: @candidate.id, candidate: candidate_attrs
      @candidate.reload
    end

    context 'when successfull' do
      it 'has updated name and salary' do
        expect(@candidate.name).to eql candidate_attrs[:name]
        expect(@candidate.salary).to eql candidate_attrs[:salary]
      end

      it 'redirect to candidates list page' do
        expect(response).to redirect_to(candidates_path)
      end
    end
  end

  context '#show' do
    let(:candidate) { create(:candidate) }

    before(:each) do
      get :show, id: candidate.id
    end

    it 'responds with HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "show"' do
      expect(response).to render_template('show')
    end
  end
end