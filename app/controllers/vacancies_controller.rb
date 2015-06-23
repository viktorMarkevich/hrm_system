# coding: utf-8

class VacanciesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_vacancy, only: [:show, :edit, :update]

  def index
    @vacancies = Vacancy.all
  end

  def new
    @vacancy = Vacancy.new
  end

  def show
  end

  def edit
  end


  def create
    @vacancy = Vacancy.new(vacancy_params)
    if @vacancy.save
      flash[:notice] = 'Вакансия была успешно создана.'
      redirect_to vacancies_path
    else
      render 'new'
    end
  end

  def update
    if @vacancy.update(vacancy_params)
      flash[:notice] = 'Вакансия успешно обновлена.'
      redirect_to vacancies_path
    else
      render 'edit'
    end
  end

  private
    def vacancy_params
      params.require(:vacancy).permit(
        :name, :salary,
        :salary_format, :region_id,
        :languages, :status,
        :requirements
      )
    end

    def get_vacancy
      @vacancy = Vacancy.find(params[:id])
    end
end
