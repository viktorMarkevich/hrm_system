require 'rails_helper'

RSpec.describe ArchivesHelper, type: :helper do

  let(:candidate) { create :candidate }

  context 'methods helper' do
    it 'method desired_salary_for' do
      expect(helper.object_path([candidate])).to eq('/candidates')
    end
  end
end