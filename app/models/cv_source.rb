class CvSource < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
