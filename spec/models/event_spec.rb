require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'check validations' do
    context 'when valid'do
      it 'has valid factory' do
        expect(build(:event)).to be_valid
      end
    end

    context 'when invalid' do
      it 'has no name' do
        expect(build(:invalid_event)).to_not be_valid
      end

      it 'created in the past' do
        event = build(:event, will_begin_at: Date.yesterday)
        expect(event).to_not be_valid
        expect(event.errors[:will_begin_at]).to include('Дата должна быть предстоящей!')
      end
    end
  end
end
