class Sticker < ActiveRecord::Base
  acts_as_paranoid

  after_create :notice_of_appointment

  STATUS_M = %w(В\ процессе Отложен Выполнен)
  STATUS_D = %w(Отложен Закрыт)
  STATUS = %w(Назначен Прочитан В\ процессе Выполнен Отложен Закрыт)
  PROGRESS = %w(0% 10% 20% 30% 40% 50% 60% 70% 80% 90% 100%)

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

  def is_director?
    self.post == 'Директор'
  end

  def self.get_relations
    [:owner, :performer]
  end

end