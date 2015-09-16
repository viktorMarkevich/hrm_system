class Event < ActiveRecord::Base

  extend SimpleCalendar
  has_calendar
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_one :staff_relation

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

  def self.events_current_month(date, the_exact_date = nil)
    if the_exact_date.present?
      date_arr = date.strftime('%F').split('-')
      year = date_arr[0]
      month = date_arr[1]
      day = date_arr[2]
      Event.where("date_part('year', starts_at) = ? and date_part('month', starts_at) = ? and date_part('day', starts_at) = ?", year, month, day)
    else
      period = date.to_date
      Event.where(starts_at: period.beginning_of_month..period.end_of_month).includes(:staff_relation)
    end
  end

end
