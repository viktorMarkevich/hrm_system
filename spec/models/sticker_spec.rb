require 'rails_helper'

RSpec.describe Sticker, type: :model do

  context 'when valid'do
    it 'has valid factory' do
      expect(build(:sticker)).to be_valid
    end

    it 'is valid without description' do
      expect(build(:sticker, description: nil)).to be_valid
    end
  end

  context 'when invalid' do
    it 'is invalid without title' do
      untitled_sticker = build(:sticker, title: nil)
      expect(untitled_sticker).to_not be_valid
    end

    it 'has error message when title is too short' do
      sticker = build(:sticker, title: 'test')
      expect(sticker).to_not be_valid
      expect(sticker.errors[:title]).to include('is too short')
    end

    it 'has error message when title is too long' do
      sticker = build(:sticker, title: 'This is too long title')
      expect(sticker).to_not be_valid
      expect(sticker.errors[:title]).to include('is too long')
    end

    it 'has error message when description is too long' do
      sticker = build(:sticker, description: 'test' * 15)
      expect(sticker).to_not be_valid
      expect(sticker.errors[:description]).to include('is too long')
    end
  end
end