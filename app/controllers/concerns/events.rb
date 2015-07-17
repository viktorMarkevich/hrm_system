module Events
  extend ActiveSupport::Concern

  included do
    before_filter :set_events, only: [:index, :new, :edit, :show]
  end

  def set_events
    @events = Event.where('created_at > ?', 2.days.ago).order(starts_at: :asc)
  end

end