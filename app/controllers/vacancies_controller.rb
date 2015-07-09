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
    @candidates = @vacancy.candidates_with_status(StaffRelation::STATUSES[0])
    if @candidates.count > 0
      @candidates
    else
      @candidates = Candidate.all
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
    @vacancy.associate_with_region(params[:region])
    if @vacancy.update_attributes(vacancy_params)

      flash[:notice] = 'Вакансия успешно обновлена.'
      redirect_to vacancies_path
    else
      render 'edit'
    end
  end

  def search_candidates_by_status
    vacancy = Vacancy.find(params[:vacancy_id])
    status = StaffRelation::STATUSES[params[:status_index].to_i]
    found_candidates = vacancy.candidates_with_status(status)

    render json: {
            candidates: found_candidates,
            statuses: StaffRelation::STATUSES,
            vacancy_id: vacancy.id,
            current_status: status
          }.to_json

  end

  def change_candidate_status
    staff_relation = StaffRelation.where(vacancy_id: params[:vacancy_id], candidate_id: params[:candidate_id]).first_or_create
    if staff_relation.update(status: params[:status])
      render json: { status: :ok }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  def add_candidates
    status = StaffRelation::STATUSES[0]
    params_candidates_ids = params[:candidates_ids].map { |x| x.to_i }
    vacancy_candidates_ids = Vacancy.find(params[:vacancy_id]).candidates.pluck(:id)
    candidates_ids_to_update = params_candidates_ids & vacancy_candidates_ids
    new_candidates_ids = params_candidates_ids - vacancy_candidates_ids
    new_candidates_ids.each do |id|
      puts "new cand id = #{id}"
      StaffRelation.create(vacancy_id: params[:vacancy_id], candidate_id: id, status: status)
    end
    candidates_ids_to_update.each do |id|
      puts "update cand id = #{id}"
      staff_relation = StaffRelation.where(vacancy_id: params[:vacancy_id], candidate_id: id).first
      staff_relation.update(vacancy_id: params[:vacancy_id], candidate_id: id, status: status)
    end
    render json: { status: 'ok' }
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
