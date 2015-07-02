class Sticker < ActiveRecord::Base
  validates :description, presence: true, length: { maximum: 50, message: 'is too long' }
end
