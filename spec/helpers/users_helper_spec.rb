require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do

  let(:user) { create :user }

  context 'full name provided' do
    it 'returns full name' do
      expect(helper.full_name_for(user)).to eq(full_name_for(user))
    end
  end

end