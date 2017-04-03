# coding: utf-8

class VacanciesController < ApplicationController
  include RegionSupporter

  before_action :authenticate_user!
  before_action :set_vacancy, only: [:show, :edit, :update, :destroy]

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
        format.json
    end
  end

  def vacancy_candidates
    @vacancy_candidates = Vacancy.find(params[:id]).candidates
    p 'q'*100
    p @vacancy_candidates
    render json: @vacancy_candidates
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
      if !vacancy_params.nil? && @vacancy.update_attributes(vacancy_params)
        format.html { redirect_to vacancy_path(@vacancy), notice: 'Вакансия успешно обновлена.' }
        format.json
      else
        format.html { render action: 'edit' }
        format.json { render json: @vacancy.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @vacancy.destroy
    respond_to do |format|
      format.html { redirect_to vacancies_url, notice: 'Вакансии успешно удалено.' }
      format.json { head :no_content }
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
          params[:vacancy][:sr_status].present?&&
          params[:id].present?
    end

    def vacancy_params
      params.require(:vacancy).permit(:name, :salary, :salary_format, :languages,
                                      :requirements, :region_id, :sr_status, :user_id)
    end

    def set_vacancy
      if Vacancy.where(:id => params[:id]).present?
        @vacancy = Vacancy.find(params[:id])
      else
        redirect_to vacancies_url
      end
    end
end
