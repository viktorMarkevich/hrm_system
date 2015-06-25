class Vacancy < ActiveRecord::Base
  include RegionSupporter

  belongs_to :region
  validates :name, :region_id, :status, presence: true

end
