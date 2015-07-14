module RegionSupporter
  extend ActiveSupport::Concern

  def region_name
    self.region.present? ? self.region.name : ''
  end

  def associate_with_region(region_name)
    region = Region.find_or_create_by(name: region_name)
    self.region_id = region.id
  end
end