class CvSourcesController < ApplicationController

  def index
    @cv_sources = CvSource.pluck(:name)
    respond_to do |format|
      format.json
    end
  end

end