class Sticker < ActiveRecord::Base

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :performer, class_name: 'User', foreign_key: 'performer_id'

  validates :description, :owner_id, presence: true
  validates :description, length: { maximum: 50, message: 'is too long' }
end
