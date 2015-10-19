class Event < ActiveRecord::Base

  extend SimpleCalendar
  has_calendar
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_one :staff_relation
  has_one :vacancy, through: :staff_relation
  has_one :candidate, through: :staff_relation

  validates :name,  :description, presence: true
  validate :future_event?

  MONTHS = %w(Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь)

  def future_event?
    errors.add(:starts_at, 'дата должна быть предстоящей!') unless starts_at.future?
  end

  def self.events_soon_mailer
    @events_soon = where(starts_at: Time.now..(Time.now + 1.day))
    NoticeMailer.event_soon(@events_soon).deliver_now if @events_soon.present?
  end

  def self.events_current_month(date, the_exact_date = nil)
    if the_exact_date.present?
      date = Time.zone.parse(date.strftime('%F'))
      where('starts_at BETWEEN ? AND ?', date, date + 23.hours + 59.minutes + 59.seconds)
    else
      period = date.to_date
      where(starts_at: period.beginning_of_month..period.end_of_month).includes(:staff_relation)
    end
  end

end
