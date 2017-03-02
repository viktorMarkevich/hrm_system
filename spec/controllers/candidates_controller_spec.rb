require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do

  let(:user) { create(:user) }
  let(:candidate) { create(:candidate) }

  before { sign_in user }

  context '#index' do
    before { get :index }

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "index" template' do
      expect(response).to render_template('index')
    end

    it 'has candidates list with only created candidate' do
      expect(assigns(:candidates)).to eq([candidate])
    end
  end

  context '#create' do
    context 'when successful' do
      before { post :create, params: {candidate: attributes_for(:candidate) }}

      it 'creates new Candidate object' do
        expect(assigns(:candidate)).to eq(Candidate.last)
      end

      it 'redirects to candidates list page' do
        expect(response).to redirect_to candidates_path
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
    before { get :edit, params:{id: candidate} }

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'renders "edit" template' do
      expect(response).to render_template('edit')
    end
  end

  context '#show' do
    before { get :show, params: {id: candidate} }

    it 'responds with HTTP 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'renders "show" template' do
      expect(response).to render_template('show')
    end
  end

  context '#update' do
    context 'when successful' do
      let(:candidate_attrs) { { name: 'Rick Grimes', salary: '500' } }

      before do
        put :update, params: {id: candidate, candidate: candidate_attrs}
        candidate.reload
      end

      it 'has updated name and salary' do
        expect(candidate.name).to eql candidate_attrs[:name]
        expect(candidate.salary).to eql candidate_attrs[:salary]
      end

      it 'redirect to candidates list page' do
        expect(response).to redirect_to(candidate_path(candidate))
      end
    end

    context 'when failed' do
      it 'renders "edit" template' do
        put :update, params: {id: candidate,  candidate: { status: nil }}
        candidate.reload

        expect(response).to render_template('edit')
      end
    end
  end

  context '#upload_resume' do
    context 'when successful' do
      before do
        post :upload_resume, params: {upload_resume: { file: fixture_file_upload("#{Rails.root}/spec/fixtures/files/CV_ENG.docx", 'text/docx') }}
        @candidate = Candidate.last
      end

      it 'has created new candidate' do
        expect(@candidate.name).to eql 'MAX SYZONENKO'
        expect(@candidate.email).to eql 'max.s32@i.ua'
        expect(@candidate.phone).to eql '38-063-895-1-895, 38-063-553-08-61'
        expect(@candidate.source).to eql 'CV_ENG.docx'
      end

      it 'redirect_to edit uploaded candidate' do
        expect(response).to redirect_to edit_candidate_path(@candidate)
      end
    end
  end
end