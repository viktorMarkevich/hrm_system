module Events
  extend ActiveSupport::Concern

  included do
    before_filter :set_events, only: [:index, :new, :edit, :show]
  end

  def set_events
    @events = Event.where(starts_at: Date.today..(Date.today+2.days+24.hours)).order(created_at: :asc)
  end

end