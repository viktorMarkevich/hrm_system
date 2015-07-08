require 'rails_helper'

describe User do

  context 'check validations' do
    context 'when valid' do
      it 'has valid factory' do
        expect(build :user).to be_valid
      end

      it { expect validate_presence_of(:email) }
      it { expect validate_presence_of(:first_name) }
      it { expect validate_presence_of(:last_name) }
      it { expect validate_presence_of(:post) }
    end

    context 'when invalid' do
      it 'has wrong email format' do
        expect(build(:user, email: 'invalid email')).to_not be_valid
      end

      it 'has invalid skype login' do
        expect(build(:user, skype: 'invalid skype login')).to_not be_valid
      end

      context 'got not unique field' do
        let(:user) { create(:user) }

        it 'email is taken' do
          expect(build(:user, email: user.email)).to_not be_valid
        end

        it 'skype is taken' do
          expect(build(:user, skype: user.skype)).to_not be_valid
        end

        it 'phone is taken' do
          expect(build(:user, phone: user.phone)).to_not be_valid
        end
      end
    end
  end
end