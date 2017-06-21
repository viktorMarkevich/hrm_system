class GeoAlternateName < ApplicationRecord

  belongs_to :geo_name, foreign_key: "geo_geoname_id"

  validates :language, uniqueness: { scope: :geo_geoname_id }

end
