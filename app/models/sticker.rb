class Sticker < ActiveRecord::Base
  validates :title, presence: true
  validates :title, length: { minimum: 5, message: 'is too short' }
  validates :title, length: { maximum: 20, message: 'is too long' }
  validates :description, presence: false, length: { maximum: 50, message: 'is too long' }
end
