class OrganisersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @stickers = Sticker.all_my_stickers(current_user).order('created_at desc').page(params[:page]).per(11)

    @events = Event.where(starts_at: Date.today..(Date.today+2.days+24.hours)).order(starts_at: :asc)

    @staff_relations = StaffRelation.order('updated_at DESC').limit(5)
  end

end
