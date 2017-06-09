require 'rails_helper'

RSpec.describe VacancyHelper, type: :helper do

  let(:user) { create :user, id: 1 }
  let(:vacancy) { create :vacancy, salary_format: 'По договоренности' }

  context 'methods helper' do
    it 'method get salary' do
      expect(helper.get_salary(vacancy)).to eq(helper.get_salary(vacancy))
    end

    it 'feedback get salary' do
      expect(helper.get_salary(vacancy)).to eq('По договоренности')
    end
  end

end