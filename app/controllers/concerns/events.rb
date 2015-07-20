module Events
  extend ActiveSupport::Concern

  included do
    before_filter :set_events, only: [:index, :new, :edit, :show]
  end

  def set_events
    @events = Event.where(starts_at: 1.days.ago..DateTime.now + 1.days).order(created_at: :asc)
  end

end