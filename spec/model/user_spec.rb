require 'spec_helper'

describe User do

  describe 'instantiation' do
    let!(:user) { build(:user) }

    it 'instantiates a list' do
      expect(user.class.name).to eq("User")
    end
  end

  it "should have valid factory" do
    build(:user).should be_valid
  end

  it "email can't be blank?" do
    build(:user, :email => "").should_not be_valid
  end

  it "format email not valid" do
    build(:user, :email => "hwerhwerh").should_not be_valid
  end

  it "fails validation without unique email" do
    create(:user)
    build(:user, email: User.last.email).should_not be_valid
  end

  it "password can't be blank?" do
    build(:user, :password => "").should_not be_valid
  end

  it "should require a email" do
    user = User.create(:email => "")
    user.valid?
    user.errors.should have_key(:email)
  end

end