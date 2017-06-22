require 'rails_helper'

RSpec.describe CvSourcesController, type: :controller do

  render_views

  let(:json) { JSON.parse(response.body) }

  describe 'GET #index' do
    before(:each) do
      5.times { create(:cv_source) }
    end

    it 'returns http success and list array of sources' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq 'application/json'
      expect(json['sources'].count).to eq(5)
    end
  end

end