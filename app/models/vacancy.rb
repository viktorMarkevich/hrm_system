class Vacancy < ActiveRecord::Base
  include RegionSupporter

  belongs_to :region
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

  validates :name, :region_id, :status, :user_id, presence: true
  validates :salary, numericality: { only_integer: true, greater_than: 0 }

end