require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #index' do

    it 'has HTTP 200 status' do
      expect(response).to have_http_status(200)
    end


  end

end
