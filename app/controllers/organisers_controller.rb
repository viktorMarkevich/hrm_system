class OrganisersController < ApplicationController

  before_action :authenticate_user!

  def index
    @stickers = current_user.stickers.order('created_at desc').page(params[:page]).per(11)

    @events = current_user.events.includes([:vacancy, :candidate]).
                                  where(will_begin_at: Time.zone.now..Time.zone.now + 7.days).
                                  order(will_begin_at: :asc)

    @changes_history = HistoryEvent.preload([:user, history_eventable: [:vacancy, :candidate]]).order('updated_at DESC').limit(5)
    @staff_relations = StaffRelation.preload([:vacancy, :candidate]).
                                     order('updated_at DESC').limit(5)
  end

end
