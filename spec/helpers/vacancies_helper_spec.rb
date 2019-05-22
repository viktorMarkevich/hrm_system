require 'rails_helper'

RSpec.describe VacanciesHelper, type: :helper do

  let(:user) { create :user, id: 1 }
  let(:vacancy) { create :vacancy, salary_format: 'По договоренности' }
  let(:vacancy_1) { create :vacancy, salary: 1500, salary_format: 'usd' }

  context 'get_salary helper method' do
    it 'method get salary' do
      expect(helper.get_salary(vacancy_1)).to eq('1500 usd')
    end

    it 'feedback get salary' do
      expect(helper.get_salary(vacancy)).to eq('По договоренности')
    end
  end

  context 'get_label_class helper method' do
    it 'should return label-default' do
      expect(helper.get_label_class('Не задействована')).to eq('label-default')
    end

    it 'should return label-success' do
      expect(helper.get_label_class('В работе')).to eq('label-success')
    end

    it 'should return label-danger' do
      expect(helper.get_label_class('Закрыта')).to eq('label-danger')
    end
  end

  context 'get_active helper method' do
    context 'when current_status is nil' do
      it 'should return active' do
        expect(helper.get_active(nil, 'Найденные')).to eq('active')
      end

      it 'should return ""' do
        expect(helper.get_active(nil, '')).to eq('')
      end
    end

    context 'when current_status is nil' do
      it 'should return active' do
        expect(helper.get_active('Найденные', 'Найденные')).to eq('active')
      end

      it 'should return ""' do
        expect(helper.get_active('Some', 'Not Some')).to eq('')
      end
    end
  end

end