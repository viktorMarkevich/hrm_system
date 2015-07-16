require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'check validations' do
    context 'when valid'do
      it 'has valid factory' do
        expect(build(:event)).to be_valid
      end
    end

    context 'when invalid' do
      it 'has no name' do
        invalid_event = build(:invalid_event)
        expect(invalid_event).to_not be_valid
      end
    end
  end
end
