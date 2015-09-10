# coding: utf-8

class VacanciesController < ApplicationController
  include RegionSupporter

  before_filter :authenticate_user!
  before_filter :find_vacancy, only: [:show, :edit, :update]

  def index
    @vacancies = Vacancy.includes(:region, :owner).order('id').page(params[:page]).per(10)
  end

  def new
    @vacancy = Vacancy.new
  end

  def show
    @sr_status = params[:sr_status] || 'Найденные'
    @vacancy_candidates = @vacancy.candidates_with_status(@sr_status)

    respond_to do |format|
        format.html
        format.js
    end
  end

  def edit
    @sr_status = params[:sr_status]
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
    if params_present?
      if params[:vacancy][:sr_status] == 'Нейтральный'
        sr = @vacancy.staff_relations.where(candidate_id: params[:vacancy][:candidate_id])
        @sr_status = sr.first.status
        sr.destroy_all
      else
        @sr_status = @vacancy.staff_relations.where(candidate_id: params[:vacancy][:candidate_id]).first.status
        StaffRelation.update_status(params)
      end
    else
      @sr_status = params[:sr_status]
    end

    @vacancy_candidates = @vacancy.candidates_with_status(@sr_status)

    respond_to do |format|
      if @vacancy.update_attributes(vacancy_params)
        format.html { redirect_to vacancies_path, notice: 'Вакансия успешно обновлена.' }
        format.js
      else
        format.html { render 'edit' }
        format.json { render json: @vacancy.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  private

    def params_present?
      params[:vacancy][:candidate_id].present? &&
          params[:vacancy][:sr_status].present?
    end

    def vacancy_params
      params.require(:vacancy).permit(
        :name, :salary,
        :salary_format,
        :languages, :status,
        :requirements, :region_id, :sr_status
      )
    end

    def find_vacancy
      @vacancy = Vacancy.find(params[:id])
    end
end
