class Event < ActiveRecord::Base

  extend SimpleCalendar
  has_calendar
  belongs_to :user
  has_one :staff_relation
  has_one :vacancy, through: :staff_relation
  has_one :candidate, through: :staff_relation

  validates :name,  :description, :user_id, presence: true
  validate :future_event?

  MONTHS = %w(Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь)

  def future_event?
    errors.add(:will_begin_at, 'Дата должна быть предстоящей!') unless will_begin_at.future?
  end

  def self.events_soon_mailer
    @events_soon = where(will_begin_at: Time.now..(Time.now + 1.day))
    NoticeMailer.event_soon(@events_soon).deliver_now if @events_soon.present?
  end

  def self.events_current_month(date, the_exact_date = nil)
    if the_exact_date.present?
      date = Time.zone.parse(date.strftime('%F'))
      where('will_begin_at BETWEEN ? AND ?', date, date + 23.hours + 59.minutes + 59.seconds)
    else
      period = date.to_date
      where(will_begin_at: period.beginning_of_month..period.end_of_month).includes(:staff_relation)
    end
  end

  def starts_at
    self.will_begin_at
  end
end
