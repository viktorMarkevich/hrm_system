require 'rails_helper'

RSpec.describe VacancyHelper, type: :helper do
  let(:user) { create :user, id: 1 }
  let(:vacancy) { create :vacancy, user_id: user.id }

  context 'methods helper' do
    it 'method get_author_and_date' do
      expect(helper.get_author_and_date(vacancy)).to eq(get_author_and_date(vacancy))
    end

    it 'method get salary' do
      expect(helper.get_salary(vacancy)).to eq(helper.get_salary(vacancy))
    end
  end

end