class SearchesController < ApplicationController

  def index
    @tags = ActsAsTaggableOn::Tag.order(:name).where('name ILIKE ?', "%#{params[:term]}%")
    respond_to do |format|
      format.json { render json: @tags.map(&:name) }
    end
  end

end