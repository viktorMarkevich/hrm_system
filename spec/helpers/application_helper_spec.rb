require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  let(:user) { create :user }

  context 'should return message or field value for an user' do
    it 'returned field value if not nil' do
      expect(helper.display_field_value_for(user.skype)).to eq(user.skype)
    end

    it 'returned message if nil' do
      @user = create(:user, skype: nil)
      expect(helper.display_field_value_for(@user.skype)).to eq('Информация не добавлена')
    end
  end
end