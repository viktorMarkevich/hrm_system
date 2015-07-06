require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'check validations' do
    context 'when valid' do
      it 'has valid factory' do
        expect(build(:company)).to be_valid
      end

      it 'can be without languages' do
        expect(build(:company, description: nil)).to be_valid
      end
    end

    context 'when invalid' do
      it 'has no name' do
        unnamed_company = build(:company, name: nil)
        expect(unnamed_company).to_not be_valid
      end

      it 'has invalid url' do
        expect(build(:company, url: 'http:/ / www.invalid_url.com')).to_not be_valid
      end
    end
  end
end