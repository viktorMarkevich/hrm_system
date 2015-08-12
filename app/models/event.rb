class Event < ActiveRecord::Base

  extend SimpleCalendar
  has_calendar
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_one :staff_relation, dependent: :destroy

  validates :name,  :description, presence: true
  validate :future_event?

  def future_event?
    errors.add(:starts_at, 'дата должна быть предстоящей!') unless starts_at.future?
  end

end
