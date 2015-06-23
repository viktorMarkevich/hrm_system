require 'rails_helper'

RSpec.describe AdminUser, type: :model do

    let!(:admin_user) { build(:admin_user) }

    describe 'instantiation' do
      it 'instantiates a list' do
        expect(admin_user.class.name).to eq('AdminUser')
      end
    end

    it 'should have valid factory' do
      expect(admin_user).to be_valid
    end

    it %q{email can't be blank?} do
      expect(build(:admin_user, email: '')).to_not be_valid
    end

    it 'format email not valid' do
      expect(build(:admin_user, email: 'hwerhwerh')).to_not be_valid
    end

    it 'fails validation without unique email' do
      admin_user = create(:admin_user)
      expect(build(:admin_user, email: admin_user.email)).to_not be_valid
    end

    it %q{password can't be blank?} do
      expect(build(:admin_user, password: '')).to_not be_valid
    end

    it 'password is too short?' do
      expect(build(:admin_user, password: 'a'*4, password_confirmation: 'a'*4)).to_not be_valid
    end

    it %q{password_confirmation doesn't match Password?} do
      expect(build(:admin_user, password_confirmation: 'gweughweoghwop')).to_not be_valid
    end

end