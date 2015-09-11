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
    @sr_status = get_staff_relation_status
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

    def get_staff_relation_status
      if params_present?
        StaffRelation.return_status(params)
      else
        @vacancy.associate_with_region(params[:region]) if params[:region].present?
        params[:sr_status]
      end
    end

    def params_present?
      params[:vacancy][:candidate_id].present? &&
          params[:vacancy][:sr_status].present?
    end

    def vacancy_params
      params.require(:vacancy).permit(:name, :salary, :salary_format, :languages,
                                      :status, :requirements, :region_id, :sr_status)
    end

    def find_vacancy
      @vacancy = Vacancy.find(params[:id])
    end
end
