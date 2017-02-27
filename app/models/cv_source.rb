class CvSource < ApplicationRecord
  has_many :candidates, dependent: :nullify
  validates :name, presence: true, uniqueness: true
end
