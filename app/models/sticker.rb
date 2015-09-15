class Sticker < ActiveRecord::Base
  acts_as_paranoid

  BG_COLOR = %w(#FF3300 #FF66FF #6666FF #00CCFF #00CC66 #009900
                #99CC00 #FFFF66 #FF9933 #FF9999 #CC6699 #CCCC00
                #FF3333 #3399FF #339966 #9900CC #D63385 #CC66FF)


  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :performer, class_name: 'User', foreign_key: 'performer_id'

  validates :description, :owner_id, presence: true
  validates :description, length: { maximum: 50, message: 'is too long' }

  scope :all_my_stickers, -> (user_id) { where('owner_id = ? OR performer_id = ?', user_id, user_id) }

  def self.get_relations
    [:owner, :performer]
  end
end