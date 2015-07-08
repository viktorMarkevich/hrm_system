class Sticker < ActiveRecord::Base
  acts_as_paranoid

  after_save :notice_of_appointment

  STATUS = ['Назначен', 'Прочитан', 'В процессе', 'Выполнен', 'Отложен', 'Закрыт']

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :performer, class_name: 'User', foreign_key: 'performer_id'

  validates :description, :owner_id, presence: true
  validates :description, length: { maximum: 50, message: 'is too long' }

  def notice_of_appointment
    if performer_id.present? && status == 'Назначен'
      NoticeMailer.notice_of_appointment(self).deliver_now
    end
  end

end
