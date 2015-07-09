require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:user) { create :user}
  let(:vacancy) { create :vacancy }

  context 'methods helper' do
    it 'method get_author_and_date' do
      expect(helper.get_author_and_date(vacancy)).to eq(get_author_and_date(vacancy))
    end

    it 'visible if director' do
      create(:user, post: 'Директор')
      expect(helper.is_director?).to eq(true)
    end
  end

  context 'returns message or field value for an user' do
    it 'returns users skype' do
      expect(helper.display_field_value_for(user.skype)).to eq(user.skype)
    end

    context 'when skype is nil' do
      it 'returns notification' do
        user = create(:user, skype: nil)
        expect(helper.display_field_value_for(user.skype)).to eq('Информация не добавлена')
      end
    end
  end
end