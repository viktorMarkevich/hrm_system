class Sticker < ActiveRecord::Base

  acts_as_paranoid

  BG_COLOR = %w(#FF8533 #FF66FF #9797FF #00CCFF #00CC66 #009900
                #99CC00 #FFFF66 #FF9933 #FF9999 #CC6699 #CCCC00
                #FF6666 #3399FF #339966 #9900CC #D63385 #CC66FF)

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

  validates :description, :user_id, presence: true
  validates :description, length: { maximum: 50, message: 'is too long' }

  scope :not_blue, -> { where.not(bg_color: 'blue') }

end