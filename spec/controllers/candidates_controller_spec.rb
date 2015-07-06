require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  before(:each) do
    user = create(:user)

    sign_in user
  end

  let(:candidate) { create(:candidate) }

  context '#create' do
    context 'check validations' do
      context 'when successful' do
        before(:each) { post :create, candidate: attributes_for(:candidate) }

        it 'creates new Candidate object' do
          expect(assigns(:candidate)).to eq(Candidate.last)
        end

        it 'redirects to candidates list page' do
          expect(response).to redirect_to candidates_path
        end
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

    it 'creates Candidate class instance' do
      expect(assigns(:candidate)).to be_a_new(Candidate)
    end

  end

  context '#edit' do
    before(:each) { get :edit, id: candidate }

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    before(:each) { get :show, id: candidate.id }

    it 'responds with HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders template "show"' do
      expect(response).to render_template('show')
    end
  end

  context '#update' do
    let(:candidate_attrs) { { name: 'Rick Grimes', salary: '500' } }

    before(:each) do
      put :update, id: candidate.id, candidate: candidate_attrs
      candidate.reload
    end

    context 'check validations' do
      context 'when successful' do
        it 'has updated name and salary' do
          expect(candidate.name).to eql candidate_attrs[:name]
          expect(candidate.salary).to eql candidate_attrs[:salary]
        end

        it 'redirect to candidates list page' do
          expect(response).to redirect_to(candidates_path)
        end
      end
    end
  end
end