# coding 'utf-8'
class GeoNamesController < ApplicationController

  before_filter :authenticate_user!

  def index
    geo_alternate_name_list = GeoAlternateName.joins(:geo_name).where(language: 'ru', geo_names: {fclass: 'P'}).pluck(:name)
    respond_to do |format|
      format.html
      format.json {render json: geo_alternate_name_list}
    end
  end
end