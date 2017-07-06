require 'rails_helper'

RSpec.describe Event, type: :model do

  describe 'check validations' do
    let(:user) { create :user }
    let(:event) { Event.new(name: 'Name', will_begin_at: rand(Time.zone.now..Time.zone.now + 7.days),
                            description: 'описание события', user_id: user.id) }
    let(:invalid_event) { Event.new(name: nil, will_begin_at: rand(Time.zone.now..Time.zone.now + 7.days),
                                    description: 'описание события', user_id: user.id) }

    context 'when valid'do
      it 'has valid factory' do
        expect(event).to be_valid
      end
    end

    context 'when invalid' do
      it 'has no name' do
        expect(invalid_event).to_not be_valid
      end

      it 'created in the past' do
        event = Event.new(name: 'Name', will_begin_at: Date.yesterday, description: 'описание события', user_id: user.id)
        expect(event).to_not be_valid
        expect(event.errors[:will_begin_at]).to include('должно быть предстоящим')
      end
    end
  end

end