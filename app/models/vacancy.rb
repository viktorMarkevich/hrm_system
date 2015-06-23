class Vacancy < ActiveRecord::Base

  belongs_to :region
  validates :name, :region_id, :status, presence: true

end
