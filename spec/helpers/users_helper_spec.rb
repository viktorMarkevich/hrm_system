require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do

  let(:user) { create :user }

  context 'should return full name for an user' do
    it 'page have full name for user' do
      expect(helper.full_name_for(user)).to eq(full_name_for(user))
    end
  end
end