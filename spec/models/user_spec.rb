require 'rails_helper'

describe User do

  let!(:user) { build(:user) }

  describe 'instantiation' do
    it 'instantiates a list' do
      expect(user.class.name).to eq('User')
    end
  end

  it 'should have valid factory' do
    expect(user).to be_valid
  end

  it "email can't be blank?" do
    expect(build(:user, email: '')).to_not be_valid
  end

  it 'format email not valid' do
    expect(build(:user, email: 'hwerhwerh')).to_not be_valid
  end

  it 'fails validation without unique email' do
    user = create(:user)
    expect(build(:user, email: user.email)).to_not be_valid
  end

  it "password can't be blank?" do
    expect(build(:user, password: '')).to_not be_valid
  end
end