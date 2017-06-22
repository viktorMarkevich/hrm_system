class SearchesController < ApplicationController

  def index
    tags = ActsAsTaggableOn::Tag.where('name ILIKE ?', "%#{params[:term]}%").order('name ASC')
    
    respond_to do |format|
      format.json { render json: tags.map(&:name) }
    end
  end

end