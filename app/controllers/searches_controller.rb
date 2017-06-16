class SearchesController < ApplicationController

  def index
    @tags = ActsAsTaggableOn::Tag.order(:name).where('name ILIKE ?', "%#{params[:term]}%")
    render json: @tags.map(&:name)
  end
end
