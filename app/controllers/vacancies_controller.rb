class VacanciesController < ApplicationController

  before_filter :get_vacancy, only: [:show, :edit]

  def new
    @vacancy = Vacancy.new
  end

  def edit

  end

  def index
    @vacancies = Vacancy.all
  end

  def show

  end

  private
    def get_vacancy
      @vacancy = Vacancy.find(params[:id])
    end
end
