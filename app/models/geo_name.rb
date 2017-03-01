class GeoName < ApplicationRecord
  has_many :geo_alternate_names, foreign_key: 'geo_geoname_id'
  validates :name, uniqueness: true
end
