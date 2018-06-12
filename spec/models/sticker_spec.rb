require 'rails_helper'

RSpec.describe Sticker, type: :model do

  context 'when return not_blue color'do
    let(:red_sticker) { create :sticker, bg_color: 'red' }
    let(:yellow_sticker) { create :sticker, bg_color: 'yellow' }
    let(:blue_sticker) { create :sticker, bg_color: 'blue' }

    before do
      red_sticker.reload
      yellow_sticker.reload
      blue_sticker.reload
    end

    it 'should return object  color' do
      not_blue = Sticker.not_blue
      expect(not_blue.count).to eq 2
      expect(not_blue.pluck(:bg_color)).to_not include('blue')
    end
  end

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

      it 'has no user_id' do
        invalid_sticker = build(:sticker, user_id: nil)
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