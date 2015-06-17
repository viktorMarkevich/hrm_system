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

  it "email can't be first name?" do
    expect(build(:user, first_name: '')).to_not be_valid
  end

  it "email can't be last name?" do
    expect(build(:user, last_name: '')).to_not be_valid
  end

  it "email can't be post?" do
    expect(build(:user, post: '')).to_not be_valid
  end

  it 'format email not valid' do
    expect(build(:user, email: 'hwerhwerh')).to_not be_valid
  end

  it 'format skype not valid' do
    expect(build(:user, skype: 'hw erh34 werh')).to_not be_valid
  end

  it 'fails validation without unique email' do
    user = create(:user)
    expect(build(:user, email: user.email)).to_not be_valid
  end

  it 'fails validation without unique skype' do
    user = create(:user, skype: 'bobfgfr')
    expect(build(:user, skype: user.skype)).to_not be_valid
  end

  it 'fails validation without unique phone' do
    user = create(:user, phone: '0936543123')
    expect(build(:user, phone: user.phone)).to_not be_valid
  end

  it "password can't be blank?" do
    expect(build(:user, password: '')).to_not be_valid
  end
end