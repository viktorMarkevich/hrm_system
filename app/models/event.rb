class Event < ActiveRecord::Base

  extend SimpleCalendar
  has_calendar

  validates :name,  presence: true

end
