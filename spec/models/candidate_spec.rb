require 'rails_helper'

RSpec.describe Candidate, type: :model do
  context 'check validations' do
    context 'when valid' do
      it 'has valid factory' do
        expect(build(:candidate)).to be_valid
      end
    end

    context 'when invalid' do
      it %q{name can't be blank} do
        expect(build(:candidate, name: '')).to_not be_valid
      end

      it %q{ desired_position can't be blank } do
        expect(build(:candidate, desired_position: '')).to_not be_valid
      end

      it %q{ status can't be blank} do
        expect(build(:candidate, status: '')).to_not be_valid
      end

      it 'format email not valid' do
        expect(build(:candidate, email: 'wrong_email')).to_not be_valid
      end

      it 'format phone not valid' do
        expect(build(:candidate, phone: '38066505512')).to_not be_valid
      end

      it 'format skype not valid' do
        expect(build(:candidate, skype: 'invalid login')).to_not be_valid
      end

      context 'got not unique field' do
        let(:candidate) { create(:candidate) }

        it 'email is taken' do
          expect(build(:candidate, email: candidate.email)).to_not be_valid
        end

        it 'skype is taken' do
          expect(build(:candidate, skype: candidate.skype)).to_not be_valid
        end

        it 'phone is taken' do
          expect(build(:candidate, phone: candidate.phone)).to_not be_valid
        end
      end

      it 'has wrong linkedin url format' do
        expect(build(:candidate, linkedin: 'wrong_url')).to_not be_valid
      end

      it 'has wrong facebook url format' do
        expect(build(:candidate, facebook: 'wrong_url')).to_not be_valid
      end

      it 'has wrong vkontakte url format' do
        expect(build(:candidate, vkontakte: 'wrong_url')).to_not be_valid
      end

      it 'has wrong google+ url format' do
        expect(build(:candidate, google_plus: 'wrong_url')).to_not be_valid
      end

      it 'has wrong home_page url format' do
        expect(build(:candidate, home_page: 'wrong_url')).to_not be_valid
      end
    end
  end
end
