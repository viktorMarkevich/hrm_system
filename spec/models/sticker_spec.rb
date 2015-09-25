require 'rails_helper'

RSpec.describe Sticker, type: :model do
  context 'check validations' do
    context 'when valid'do
      it 'has valid factory' do
        expect(build(:sticker)).to be_valid
      end
    end

    context 'when invalid' do
      it 'has no description' do
        invalid_sticker = build(:invalid_sticker)
        expect(invalid_sticker).to_not be_valid
      end

      it 'has no owner_id' do
        invalid_sticker = build(:sticker, owner_id: nil)
        expect(invalid_sticker).to_not be_valid
      end

      it 'has long description' do
        sticker = build(:sticker, description: 'test' * 15)
        expect(sticker).to_not be_valid
        expect(sticker.errors[:description]).to include('is too long')
      end
    end
  end
end