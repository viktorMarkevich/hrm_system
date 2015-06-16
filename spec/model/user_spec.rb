require 'rails_helper'

describe User do

  describe 'instantiation' do
    let!(:user) { build(:user) }

    it 'instantiates a list' do
      expect(user.class.name).to eq('User')
    end
  end

  it 'should have valid factory' do
    expect(build(:user)).to be_valid
  end

  it "email can't be blank?" do
    expect(build(:user, email: '')).to_not be_valid
  end

  it 'format email not valid' do
    expect(build(:user, email: 'hwerhwerh')).to_not be_valid
  end

  it 'fails validation without unique email' do
    create(:user)
    expect(build(:user, email: User.last.email)).to_not be_valid
  end

  it "password can't be blank?" do
    expect(build(:user, password: '')).to_not be_valid
  end

  it 'should require a email' do
    user = User.create(email: '')
    user.valid?
    expect(user.errors).to have_key(:email)
  end

  after :each do
    User.destroy_all
  end

end