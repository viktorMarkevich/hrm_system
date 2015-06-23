require 'rails_helper'

RSpec.describe Region, type: :model do
  context 'when valid' do
    it 'has valid factory' do
      expect(build(:region)).to be_valid
    end
  end

  context 'when invalid' do
    it 'is invalid without name' do
      expect(build(:region, name: nil)).to_not be_valid
    end

    it 'is invalid when region already exists' do
      create(:region, name: 'Киев')
      region = build(:region, name: 'Киев')
      expect(region).to_not be_valid
      expect(region.errors[:name]).to include('has already been taken')
    end
  end
end
