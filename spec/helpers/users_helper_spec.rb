require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do

  before :each do
    @user = create(:user)
  end

  describe '#full_name_for(user)' do

    it 'page have full name for user' do
      expect(helper.full_name_for(@user)).to eq(full_name_for(@user))
    end

  end

end