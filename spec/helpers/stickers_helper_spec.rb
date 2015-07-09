require 'rails_helper'

RSpec.describe StickersHelper, type: :helper do

  it 'method performer_array' do
    user = create(:user)
    expect(helper.performer_array).to eq([[full_name_for(user), user.id]])
  end

end