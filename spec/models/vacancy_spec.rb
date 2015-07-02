require 'rails_helper'

RSpec.describe Vacancy, type: :model do

  context 'when valid' do
    it 'has valid factory' do
      expect(build(:vacancy)).to be_valid
    end

    it 'is valid without "requirements"' do
      vacancy = build(:vacancy, requirements: nil)
      expect(vacancy).to be_valid
    end
  end

  context 'when invalid' do
    it 'is invalid without name' do
      unnamed_vacancy = build(:vacancy, name: nil)
      expect(unnamed_vacancy).to_not be_valid
    end

    it %q{ name can't be blank } do
      expect(build(:vacancy, name: '')).to_not be_valid
    end

    it %q{ region can't be blank } do
      expect(build(:vacancy, region_id: nil)).to_not be_valid
    end

    it %q{ status can't be blank } do
      expect(build(:vacancy, status: '')).to_not be_valid
    end

    it %q{ invalid if salary isn't numeric } do
      expect(build(:vacancy, salary: '1000 usd')).to_not be_valid
    end

    it 'has only integer value' do
      expect(build(:vacancy,  salary: '1000.5')).to_not be_valid
    end

  end

end
