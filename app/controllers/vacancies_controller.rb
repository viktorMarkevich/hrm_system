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
    @status = params[:status] || 'Найденные'
    @vacancy_candidates = @vacancy.candidates_with_status(@status)
    @candidates = Candidate.includes(:staff_relations)
    
    respond_to do |format|
        format.html
        format.js
    end
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
    if params_present?
      @status = @vacancy.staff_relations.where(candidate_id: params[:vacancy][:candidate_id]).first.status
      StaffRelation.update_status(params)
    else
      @status = 'Найденные'
      # @vacancy.associate_with_region(params[:region])
    end

    @vacancy_candidates = @vacancy.candidates_with_status(@status)
    @candidates = Candidate.includes(:staff_relations)

    respond_to do |format|
      if @vacancy.update_attributes(vacancy_params)
        format.html { redirect_to vacancies_path, notice: 'Вакансия успешно обновлена.' }
        format.json { head :no_content }
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

    def build_response_hash(candidates, statuses, vacancy_id, current_status)
      {
        candidates: candidates,
        statuses: statuses,
        vacancy_id: vacancy_id,
        current_status: current_status
      }.to_json
    end
end
