require 'rails_helper'

RSpec.describe Vacancy, type: :model do
  it 'has valid factory' do
    expect(build(:vacancy)).to be_valid
  end

  it 'is valid without "name"' do
    vacancy = build(:vacancy, name: nil)
    expect(vacancy).to be_valid
  end
end
