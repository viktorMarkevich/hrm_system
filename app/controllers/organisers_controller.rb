class OrganisersController < ApplicationController

  before_action :authenticate_user!

  def index
    @stickers = current_user.stickers.order('created_at desc').page(params[:page]).per(11)

    @events = current_user.events.includes([staff_relation:[:vacancy, :candidate]]).
                                  where(will_begin_at: Time.zone.now..Time.zone.now + 7.days).
                                  order(will_begin_at: :asc)

    @history_events = HistoryEvent.preload(:history_eventable, :user).order('updated_at DESC').page(params[:page]).per(5)
  end
end
