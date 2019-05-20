require 'rails_helper'

RSpec.describe CandidatesHelper, type: :helper do

  let(:user) { create :user}
  let(:vacancy) { create :vacancy }
  let(:candidate) { create :candidate }
  let!(:staff_relation) { create :staff_relation, vacancy_id: vacancy.id, candidate_id: candidate.id }

  context 'methods helper' do
    it 'method desired_salary_for' do
      expect(helper.desired_salary_for(candidate)).to eq('300 usd')
    end

    it 'method set_the_percentage_of_completed_fields' do
      expect(helper.set_the_percentage_of_completed_fields(candidate)).to eq(75.9)
    end

    context 'method get_sr_label_class' do

      it "when 'Найденные'" do
        expect(helper.get_sr_label_class('Найденные')).to eq('label-default')
      end

      it "when 'Отобранные'" do
        expect(helper.get_sr_label_class('Отобранные')).to eq('label-primary')
      end

      it "when 'Собеседование'" do
        expect(helper.get_sr_label_class('Собеседование')).to eq('label-info')
      end

      it "when 'Утвержден'" do
        expect(helper.get_sr_label_class('Утвержден')).to eq('label-success')
      end

      it "when 'Не подходит'" do
        expect(helper.get_sr_label_class('Не подходит')).to eq('label-warning')
      end

      it "when 'Отказался'" do
        expect(helper.get_sr_label_class('Отказался')).to eq('label-danger')
      end

      it "when 'some status'" do
        expect(helper.get_sr_label_class('some status')).to eq([])
      end
    end

    it 'method sr_status' do
      expect(helper.sr_status(vacancy, candidate)).to eq('Найденные')
    end
  end
end
