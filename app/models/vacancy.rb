class Vacancy < ActiveRecord::Base

  belongs_to :region
  validates :name, :region_id, :status, presence: true

  def get_assigned_region_name
    self.region.present? ? self.region.name : ''
  end

end
