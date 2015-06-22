class Company < ActiveRecord::Base
  belongs_to :region

  validates :region_id, presence: true
end