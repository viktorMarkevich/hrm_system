require 'rails_helper'

RSpec.describe Image, type: :model do

  # describe Image do
  #
  #   let(:user) { FactoryGirl.create(:user) }
  #   let(:image) {FactoryGirl.create(:image)}
  #   before { @image.avatar = File.new('app/assets/images/missing_medium.png')}
  #
  #   subject { @image }
  #
  #
  #   it { should respond_to(:user_id) }
  #   it { should have_attached_file(:avatar) }
  #   it { should validate_attachment_presence(:avatar) }
  #   it { should respond_to(:user) }
  #
  #   it { should be_valid }
  #
  #   describe "when user_id is not present" do
  #     before { @image.user_id = nil }
  #     it { should_not be_valid }
  #   end
  #
  # end
end
