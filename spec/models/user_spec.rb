require 'rails_helper'

describe User do

  context 'should have valid factory' do
    it 'expect valid factory' do
      expect(build :user).to be_valid
    end
  end

  context 'should have presence validation' do
    it { expect validate_presence_of(:email) }
    it { expect validate_presence_of(:first_name) }
    it { expect validate_presence_of(:last_name) }
    it { expect validate_presence_of(:post) }
  end

  context 'should have format validation' do
    it 'format email not valid' do
      expect(build(:user, email: 'hwerhwerh')).to_not be_valid
    end

    it 'format skype not valid' do
      expect(build(:user, skype: 'hw erh34 werh')).to_not be_valid
    end
  end

  context 'should have uniq validation' do
    let(:user) { create(:user) }

    it 'should have uniq unique email' do
      expect(build(:user, email: user.email)).to_not be_valid
    end

    it 'should have uniq unique skype' do
      expect(build(:user, skype: user.skype)).to_not be_valid
    end

    it 'should have uniq unique phone' do
      expect(build(:user, phone: user.phone)).to_not be_valid
    end
  end
end