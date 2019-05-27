require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  render_views

  let(:admin_user) { create(:admin_user) }
  let(:user) { create(:user) }

  before { sign_in admin_user }

  context '#index' do
    it 'has HTTP 200 status' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

end