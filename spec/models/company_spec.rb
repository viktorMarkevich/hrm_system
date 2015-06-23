require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'when valid' do
    it 'has valid factory' do
      expect(build(:company)).to be_valid
    end

    it 'is valid without languages' do
      expect(build(:company, description: nil)).to be_valid
    end
  end

  context 'when invalid' do
    it 'is invalid without name' do
      unnamed_company = build(:company, name: nil)
      expect(unnamed_company).to_not be_valid
    end

    it "name can't be blank" do
      expect(build(:company, name: '')).to_not be_valid
    end

    it 'format url not valid' do
      expect(build(:company, url: 'http:/ / www.vdvdfv.com')).to_not be_valid
    end

  end

end