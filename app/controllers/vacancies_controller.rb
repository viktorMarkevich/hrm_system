# coding: utf-8
class VacanciesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_vacancy, only: [ :show, :edit, :update, :destroy ]

  def index
    @vacancies = Vacancy.includes(:owner).order('id').page(params[:page]).per(10)
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
    @vacancy = Vacancy.find(params[:id])
    if @vacancy.candidates.count > 0
      @vacancy_candidates = @vacancy.candidates
    else
      @vacancy_candidates = Candidate.all
    end
    render json: { candidates: @vacancy_candidates, cand_count: Candidate.all.count }
  end

  def edit
    @sr_status = params[:sr_status]
  end

  def create
    @vacancy = current_user.vacancies.build(vacancy_params)
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
      if @vacancy.update(vacancy_params)
        format.html { redirect_to vacancy_path(@vacancy), notice: 'Вакансия успешно обновлена.' }
        format.json
      else
        format.html { render action: 'edit' }
        format.json { render json: @vacancy.errors.full_messages, status: :unprocessable_entity }
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
      params[:sr_status]
    end
  end

  def params_present?
    params[:vacancy][:candidate_id].present? && params[:vacancy][:sr_status].present? && params[:id].present?
  end

  def vacancy_params
    params.require(:vacancy).permit(:name, :salary, :salary_format, :languages, :requirements, :region, :sr_status, :user_id)
  end

  def set_vacancy
    if Vacancy.where(id: params[:id]).present?
      @vacancy = Vacancy.find(params[:id])
    else
      redirect_to vacancies_url
    end
  end

end
