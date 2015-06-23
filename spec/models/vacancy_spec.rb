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

    it "name can't be blank" do
      expect(build(:vacancy, name: '')).to_not be_valid
    end

    it "region can't be blank" do
      expect(build(:vacancy, region_id: nil)).to_not be_valid
    end

    it "status can't be blank" do
      expect(build(:vacancy, status: '')).to_not be_valid
    end

  end

end
