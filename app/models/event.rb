class Event < ActiveRecord::Base

  extend SimpleCalendar
  has_calendar

  validates :name,  presence: true
  validate :future_event?

  def future_event?
    errors.add(:starts_at, 'дата должна быть предстоящей!') unless starts_at.future?
  end

end
