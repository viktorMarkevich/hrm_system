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
      before { post :create, candidate: attributes_for(:candidate) }

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

    it 'renders "show" template' do
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
        expect(response).to redirect_to(candidate_path(candidate))
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

  context '#upload_resume' do
    context 'when successful' do
      before do
        request.env["HTTP_REFERER"] = "where_i_came_from"
        post :upload_resume, upload_resume: { file: fixture_file_upload("#{Rails.root}/spec/fixtures/files/CV_ENG.docx", 'text/docx') }
      end

      it 'has created new candidate' do
        candidate = Candidate.last
        expect(candidate.name).to eql "fake_name"
        expect(candidate.email).to eql "max.s32@i.ua"
        expect(candidate.phone).to eql "38-063-895-1-895, 38-063-553-08-61"
      end

      it 'redirect_to back' do
        response.should redirect_to "where_i_came_from"
      end
    end

  end
end