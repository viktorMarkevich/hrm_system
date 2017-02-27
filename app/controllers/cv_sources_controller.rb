class CvSourcesController < ApplicationController
  def index
    @cv_sources = CvSource.all
    respond_to do |format|
      format.json
    end
  end
end
