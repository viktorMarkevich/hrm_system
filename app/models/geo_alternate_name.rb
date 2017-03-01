class GeoAlternateName < ApplicationRecord
  belongs_to :geo_name, foreign_key: "geo_geoname_id"
  validates_uniqueness_of :language, scope: :geo_geoname_id
end
