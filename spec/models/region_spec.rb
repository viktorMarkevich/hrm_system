require 'rails_helper'

RSpec.describe Region, type: :model do
  context 'check validations' do
    let(:region) { create(:region, name: 'Киев') }

    context 'when valid' do
      it 'has valid factory' do
        expect(region).to be_valid
      end
    end

    context 'when invalid' do
      it 'has no name' do
        expect(build(:region, name: nil)).to_not be_valid
      end

      it 'has existed name' do
        new_region = build(:region, name: region.name)
        expect(new_region).to_not be_valid
        expect(new_region.errors[:name]).to include('has already been taken')
      end
    end
  end
end
