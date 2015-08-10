class Sticker < ActiveRecord::Base
  acts_as_paranoid

  after_create :notice_of_appointment

  MANAGER_STATUS = %w(В\ процессе Отложен Выполнен)
  DIRECTOR_STATUS = %w(Отложен Закрыт)
  STATUS = %w(Назначен Отложен Закрыт)
  BG_COLOR = %w(#FF3300 #FF66FF #6666FF #00CCFF #00CC66 #009900
                #99CC00 #FFFF66 #FF9933 #FF9999 #CC6699 #CCCC00
                #FF3333 #0033CC #339966 #9900CC #D63385 #CC66FF)


  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :performer, class_name: 'User', foreign_key: 'performer_id'

  validates :description, :owner_id, presence: true
  validates :description, length: { maximum: 50, message: 'is too long' }

  def notice_of_appointment
    if self.performer_id
      NoticeMailer.notice_of_appointment(self).deliver_now
      self.update(status: 'Назначен')
    end
  end

  def self.get_relations
    [:owner, :performer]
  end

  def is_destroyed?
    if self.performer_id && self.destroy
      NoticeMailer.notice_of_appointment(self).deliver_now
    else
      self.destroy
    end || false
  end
end