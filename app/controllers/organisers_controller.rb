class OrganisersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @stickers = current_user.owner_stickers.order('created_at desc').page(params[:page]).per(11)

    @events = Event.where(starts_at: Date.today..(Date.today + 7.days + 24.hours)).order(starts_at: :asc)

    @staff_relations = StaffRelation.order('updated_at DESC').limit(5)
  end

end
