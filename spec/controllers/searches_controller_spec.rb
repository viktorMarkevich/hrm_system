require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  let(:json) { JSON.parse(response.body) }
  let(:candidate) { create :candidate }

  describe 'GET #index' do

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'responds to custom formats when provided in the params' do
      get :index, format: :json
      expect(response.content_type).to eq 'application/json'
    end

    it 'returns json array of tags' do
      candidate.tag_list.add('ruby', 'on', 'rails')
      candidate.save
      candidate.reload
      get :index, format: :json
      expect(json).to eq candidate.tag_list.sort
    end
  end

end