require 'rails_helper'

RSpec.describe Candidate, type: :model do
  context 'when valid'do
    it 'has valid factory' do
      expect(build(:candidate)).to be_valid
    end

    it 'is valid without experiences' do
      expect(build(:candidate, experience: nil)).to be_valid
    end
  end

  context 'when invalid' do
    it 'is invalid without name' do
      unnamed_candidate = build(:candidate, name: nil)
      expect(unnamed_candidate).to_not be_valid
    end

    it %q{name can't be blank} do
      expect(build(:candidate, name: '')).to_not be_valid
    end

    it "desired_position can't be blank" do
      expect(build(:candidate, desired_position: '')).to_not be_valid
    end

    it "status can't be blank" do
      expect(build(:candidate, status: '')).to_not be_valid
    end

    it 'format email not valid' do
      expect(build(:candidate, email: 'hwerhwerh')).to_not be_valid
    end

    it 'format phone not valid' do
      expect(build(:candidate, phone: '38066505512')).to_not be_valid
    end

    it 'format skype not valid' do
      expect(build(:candidate, skype: 'aw dfg23 djkl')).to_not be_valid
    end

    it 'fails validation without unique email' do
      candidate = create(:candidate)
      expect(build(:candidate, email: candidate.email)).to_not be_valid
    end

    it 'fails validation without unique skype' do
      candidate = create(:candidate, skype: 'bobfgfr')
      expect(build(:candidate, skype: candidate.skype)).to_not be_valid
    end

    it 'fails validation without unique phone' do
      candidate = create(:candidate, phone: '+380936543123')
      expect(build(:candidate, phone: candidate.phone)).to_not be_valid
    end

  end

end
