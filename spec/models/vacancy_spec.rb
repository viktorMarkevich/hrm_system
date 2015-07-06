require 'rails_helper'

RSpec.describe Vacancy, type: :model do
  context 'check validations' do
    context 'when valid' do
      it 'has valid factory' do
        expect(build(:vacancy)).to be_valid
      end

      it 'can be without requirements' do
        vacancy = build(:vacancy, requirements: nil)
        expect(vacancy).to be_valid
      end
    end

    context 'when invalid' do
      it 'has no name' do
        unnamed_vacancy = build(:vacancy, name: nil)
        expect(unnamed_vacancy).to_not be_valid
      end

      it %q{ name is blank } do
        expect(build(:vacancy, name: '')).to_not be_valid
      end

      it %q{ region is blank } do
        expect(build(:vacancy, region_id: nil)).to_not be_valid
      end

      it %q{ status is blank } do
        expect(build(:vacancy, status: '')).to_not be_valid
      end

      it %q{ salary is not numeric } do
        expect(build(:vacancy, salary: '1000 usd')).to_not be_valid
      end

      it 'salary is not integer' do
        expect(build(:vacancy,  salary: '1000.5')).to_not be_valid
      end

    end
  end
end
