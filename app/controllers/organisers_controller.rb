class OrganisersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @stickers = Sticker.includes(:owner, :performer).order('created_at desc').page(params[:page]).per(11)
    @stickers = @stickers.where('performer_id = ?', "#{current_user.id}") unless current_user.is_director?

    @events = Event.where(starts_at: Date.today..(Date.today+2.days+24.hours)).order(starts_at: :asc)

    @staff_relations = StaffRelation.order('updated_at DESC').limit(5)
  end

end
