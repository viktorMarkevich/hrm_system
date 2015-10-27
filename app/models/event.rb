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

  def self.events_of(user, from, to)
    user.events.where(will_begin_at: from..to).order(will_begin_at: :asc)
  end

  def starts_at
    self.will_begin_at
  end

  private

    def self.date_in_tz(time)
      Time.zone.parse(time.strftime('%F'))
    end

end
