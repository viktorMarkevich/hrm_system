# coding: utf-8

class VacanciesController < ApplicationController
  include RegionSupporter

  before_filter :authenticate_user!
  before_filter :find_vacancy, only: [:show, :edit, :update]

  def index
    @vacancies = Vacancy.includes(:region, :owner).order('id').page(params[:page]).per(10) #expect(assigns(:vacancies)).to match_array()
  end

  def new
    @vacancy = Vacancy.new
  end

  def show
  end

  def edit
  end

  def create
    @vacancy = current_user.vacancies.build(vacancy_params)
    @vacancy.associate_with_region(params[:region])
    if @vacancy.save
      flash[:notice] = 'Вакансия была успешно создана.'
      redirect_to vacancies_path
    else
      render 'new'
    end
  end

  def update
    @vacancy.associate_with_region(params[:region])
    if @vacancy.update_attributes(vacancy_params)

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
        :salary_format,
        :languages, :status,
        :requirements
      )
    end

    def find_vacancy
      @vacancy = Vacancy.find(params[:id])
    end
end
