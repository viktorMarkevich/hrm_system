class Event < ActiveRecord::Base

  MONTHS = %w(Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь)

  belongs_to :user
  belongs_to :staff_relation, dependent: :destroy

  accepts_nested_attributes_for :staff_relation

  validates :name, :description, :user_id, presence: true
  validate :future_event?

  def future_event?
    errors.add(:will_begin_at, 'должна быть предстоящей') unless will_begin_at.future?
  end

  def self.events_of(user, from, to)
    user.events.where(will_begin_at: from..to).order(will_begin_at: :asc)
  end

  def self.events_soon_mailer
    @events_soon = where(will_begin_at: (Time.zone.now + 1.day).at_beginning_of_day()..(Time.zone.now + 1.day).at_end_of_day())
    if @events_soon.count > 0
      @events_soon.each do |event|
        if  event.staff_relation && event.staff_relation.candidate && event.staff_relation.candidate.owner
          owner = event.staff_relation.candidate.owner
          NoticeMailer.event_soon(event, owner).deliver_now
        end
        if  event.staff_relation && event.staff_relation.candidate && event.staff_relation.candidate.owner
          candidate = event.staff_relation.candidate

          NoticeMailer.event_soon_candidate(event, candidate).deliver_now
        end
        if  event.staff_relation && event.staff_relation.candidate && event.staff_relation.candidate.owner && User.where(post: 'Директор').first
          ceo = User.where(post: 'Директор').first
          NoticeMailer.event_soon(event, ceo).deliver_now
        end
      end
    end
  end

  def start_time
    self.will_begin_at
  end

end