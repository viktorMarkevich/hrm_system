require 'rails_helper'

RSpec.describe VacancyHelper, type: :helper do
  let(:user) { create :user }
  let(:vacancy) { create :vacancy }

  context 'methods helper' do
    it 'method get_author_and_date' do
      expect(helper.get_author_and_date(vacancy)).to eq(get_author_and_date(vacancy))
    end

    it 'method get salary' do
      expect(helper.get_salary(vacancy)).to eq(helper.get_salary(vacancy))
    end
  end

end