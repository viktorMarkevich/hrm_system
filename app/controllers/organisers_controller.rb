class OrganisersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @stickers = current_user.owner_stickers.order('created_at desc').page(params[:page]).per(11)

    @events = Event.includes([:vacancy, :candidate]).
                    where(starts_at: Date.today..Date.today.next_week).
                    order(starts_at: :asc)

    @staff_relations = StaffRelation.includes([:vacancy, :candidate]).
                                     order('updated_at DESC').limit(5)
  end

end
