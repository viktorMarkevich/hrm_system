require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  render_views

  let(:user) { create(:user) }
  let(:candidate) { create(:candidate) }
  let(:json) { JSON.parse(response.body) }

  describe 'GET #index' do

    before(:each) do
      create(:tag)
    end

    it 'returns array of tags' do
      get :index, format: :json
      expect(response).to have_http_status(200)
      expect(assigns(:tags)).to eq([tags])
    end
  end

end
# Processing by SearchesController#index as JSON
# Parameters: {"term"=>""}
# ActsAsTaggableOn::Tag Load (0.7ms)  SELECT "tags".* FROM "tags" WHERE (name ILIKE '%%') ORDER BY "tags"."name" ASC
