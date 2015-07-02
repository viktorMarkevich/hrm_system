require 'rails_helper'

RSpec.describe Sticker, type: :model do

  context 'when valid'do
    it 'has valid factory' do
      expect(build(:sticker)).to be_valid
    end
  end

  context 'when invalid' do
    it 'is invalid without description' do
      invalid_sticker = build(:invalid_sticker)
      expect(invalid_sticker).to_not be_valid
    end

    it 'has error message when description is too long' do
      sticker = build(:sticker, description: 'test' * 15)
      expect(sticker).to_not be_valid
      expect(sticker.errors[:description]).to include('is too long')
    end
  end
end