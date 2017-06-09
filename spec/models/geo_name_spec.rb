require 'rails_helper'

RSpec.describe GeoName, type: :model do

  context 'check validations' do
    context 'check uniqueness' do
      it 'has valid factory' do
        expect(build(:geo_name)).to be_valid
      end

      it 'to by unique' do
        geo_name = create(:geo_name)
        geo_name2 = geo_name.dup
        expect(geo_name2).to_not be_valid
      end
    end
  end

  context 'check increment candidates_count' do
    let!(:candidate) { create(:candidate, city_of_residence: 'уругвай') }
    let!(:geo_alternate_name) { create(:geo_alternate_name) }

    it 'check candidates_count changes' do
      @candidate = candidate
      geo_name_id = geo_alternate_name.geo_geoname_id
      expect(GeoName.find(geo_name_id).candidates_count).to be_equal(0)
      @candidate.update(city_of_residence: 'Киев')
      expect(GeoName.find(geo_name_id).candidates_count).to be_equal(1)
      @candidate.update(city_of_residence: 'простоквашино')
      expect(GeoName.find(geo_name_id).candidates_count).to be_equal(0)
    end
  end

end
