require 'rails_helper'

RSpec.describe CvSource, type: :model do
  before { @cv_source = build(:cv_source) }
  subject { @cv_source }

  it { should respond_to(:name) }
  it { should be_valid }

  describe 'when name is not present' do
    before { @cv_source.name = ' ' }

    it { should_not be_valid }
  end

  describe 'when name is already taken' do
    before do
      cv_source_with_same_name = @cv_source.dup
      cv_source_with_same_name.save
    end

    it { should_not be_valid }
  end
end
