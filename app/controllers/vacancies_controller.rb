# coding: utf-8

class VacanciesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_vacancy, only: [:show, :edit, :update]

  def new
    @vacancy = Vacancy.new
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

  def edit

  end

  def update
    if @vacancy.update(vacancy_params)
      flash[:notice] = 'Вакансия успешно обновлена.'
      redirect_to vacancies_path
    else
      render 'edit'
    end
  end

  def index
    @vacancies = Vacancy.all
  end

  def show

  end

  private
    def vacancy_params
      params.require(:vacancy).permit(
        :name, :salary,
        :salary_format, :region,
        :languages, :status,
        :requirements
      )
    end

    def get_vacancy
      @vacancy = Vacancy.find(params[:id])
    end
end
