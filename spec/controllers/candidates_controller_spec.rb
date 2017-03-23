require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do

  let(:user) { create(:user) }
  let(:candidate) { create(:candidate) }
  let(:candidate_1) { create(:candidate, status: 'Пассивен') }

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

    it 'has candidates list with only created candidate' do
      expect(assigns(:candidates)).to eq([candidate])
    end
  end
  context 'index with params status: Паcсивен' do
    before { get :index, params: {status: candidate_1.status} }
    it 'has candidates list with params status: Паcсивен' do
     expect(assigns(:candidates).first.status).to eql 'Пассивен'
    end
  end

  context 'index with params status: В работе' do
    before { get :index, params: {status: candidate.status} }
    it 'has candidates list with params status: В работе' do
      expect(assigns(:candidates).map(&:status)).to include( 'В работе')

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
      let(:candidate_attrs) { { name: 'Rick Grimes', salary: '500'} }

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
        put :update, params: { id: candidate,  candidate: { status: nil } }
        candidate.reload

        expect(response).to render_template('edit')
      end
    end

    context 'when update  city_of_residence' do
      let!(:geo_alternate_name) { create(:geo_alternate_name) }
      let(:candidate_attrs) { { name: 'Rick Grimes', salary: '500', city_of_residence: "Киев" } }

      before do
        put :update, params: { id: candidate, candidate: candidate_attrs }
        candidate.reload
      end
      it 'increase candidates_count' do
        expect(GeoName.find(geo_alternate_name.geo_geoname_id).candidates_count).to be_equal(GeoName.find(geo_alternate_name.geo_geoname_id).candidates.count)
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
        expect(@candidate.file_name).to eql 'CV_ENG.docx'
      end

      it 'redirect_to edit uploaded candidate' do
        expect(response).to redirect_to edit_candidate_path(@candidate)
      end
    end
  end

  context '#index import candidates to file' do
    before do
      candidate.reload
    end

    it 'has return csv' do
      get :index, format: :csv
      expect(response.content_type).to eq "text/csv"
    end

    it 'has return pdf' do
      get :index, format: :pdf
      expect(response.content_type).to eq "application/pdf"
    end

    it 'has return xlsx' do
      get :index, format: :xlsx
      expect(response.content_type).to eq "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    end
  end

  context '#update_resume' do
    context 'when update resume' do
      let(:candidate) { create(:candidate) }

      it "change original_cv_data" do
        put :update_resume, params: { format: :json, id: candidate, original_cv_data: 'data' }
        candidate.reload
        expect(response.content_type).to eq "application/json"
        expect(candidate.original_cv_data).to eql('data')
      end
    end
  end
end