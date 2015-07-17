module Events
  extend ActiveSupport::Concern

  included do
    before_filter :set_events, only: [:index, :new, :edit, :show]
  end

  def set_events
    @events = Event.where('starts_at BETWEEN ? AND ? ', 2.days.ago, DateTime.now).order(created_at: :asc)
  end

end