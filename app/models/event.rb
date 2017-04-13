class Event < ActiveRecord::Base

  belongs_to :user
  belongs_to :staff_relation, dependent: :destroy
  accepts_nested_attributes_for :staff_relation

  validates :name, :description, :user_id, presence: true
  validate :future_event?

  MONTHS = %w(Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь)

  def future_event?
    errors.add(:will_begin_at, 'Дата должна быть предстоящей!') unless will_begin_at.future?
  end

  def self.events_of(user, from, to)
    user.events.where(will_begin_at: from..to).order(will_begin_at: :asc)
  end

  def start_time
    self.will_begin_at
  end
end
