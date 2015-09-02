class Event < ActiveRecord::Base

  extend SimpleCalendar
  has_calendar
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_one :staff_relation, dependent: :destroy

  validates :name,  :description, presence: true
  validate :future_event?

  MONTHS = %w(Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь)

  def future_event?
    errors.add(:starts_at, 'дата должна быть предстоящей!') unless starts_at.future?
  end

  def self.events_soon_mailer
    @events_soon = Event.where(starts_at: Time.now..(Time.now + 1.day))
    NoticeMailer.event_soon(@events_soon).deliver_now
  end

end
