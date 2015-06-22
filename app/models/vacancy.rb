class Vacancy < ActiveRecord::Base
  validates :name, :region, :status, presence: true
end
