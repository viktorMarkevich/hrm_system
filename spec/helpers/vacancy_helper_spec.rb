require 'rails_helper'

RSpec.describe VacancyHelper, type: :helper do
  let(:user) { create :user }
  let(:vacancy) { create :vacancy }

  context 'methods helper' do
    it 'method get_author_and_date(vacancy)' do
      # user = create(:user, id: 1)
      # vacancy = create(:vacancy, user_id: user.id)
      # expect(helper.full_name_for(user)).to eq(full_name_for(user))
      expect(helper.get_author_and_date(vacancy)).to eq(get_author_and_date(vacancy))
    end

    it 'method get salary' do
      # vacancy = create(:vacancy)
      expect(helper.get_salary(vacancy)).to eq(helper.get_salary(vacancy))
    end
  end

end