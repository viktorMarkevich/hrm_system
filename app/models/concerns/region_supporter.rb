module RegionSupporter
  extend ActiveSupport::Concern

  def region_name
    self.region.present? ? self.region.name : ''
  end
end