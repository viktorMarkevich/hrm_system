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

  def self.events_current_date_period(date, the_exact_date = nil, user)
    date_from = date_with_time_zone(date)
    date_to = set_date_to(date, the_exact_date)
    where(user_id: user.id, will_begin_at: date_from..date_to).includes(:staff_relation)
  end

  def starts_at
    self.will_begin_at
  end

  private

    def self.set_date_to(date, the_exact_date)
      the_exact_date.present? ? date_with_time_zone(the_exact_date) : date_with_time_zone(date.end_of_month)
    end

    def self.date_with_time_zone(date)
      Time.zone.parse(date.strftime('%F'))
    end
end
