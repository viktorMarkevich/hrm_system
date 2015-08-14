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
    @candidates_with_found_status = @vacancy.candidates_with_status('Найденные')
    @candidates = Candidate.includes(:staff_relations)
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
    puts "params = #{params.inspect}"
    @vacancy.associate_with_region(params[:region])
    @vacancy = Vacancy.find(params[:id])

    respond_to do |format|
      if @vacancy.update_attributes(vacancy_params)
        format.html { redirect_to vacancies_path, notice: 'Вакансия успешно обновлена.' }
        format.json { render json: { status: :ok } }
      else
        format.html { render 'edit' }
        format.json { render json: { status: :unprocessable_entity } }
      end
    end
  end

  def search_candidates_by_status
    vacancy = Vacancy.find(params[:id])
    @matched_candidates = vacancy.candidates_with_status(params[:status])

    render json: build_response_hash(@matched_candidates,
                                     StaffRelation::STATUSES,
                                     vacancy.id,
                                     params[:status])
  end

  def change_candidate_status
    #FIXME: Не работает выборка в контроллере! В консоли работает!
    staff_relation = StaffRelation.find_by_vacancy_id_and_candidate_id(params[:id],params[:candidate_id])

    unless params[:status] == 'Нейтральный'
      if staff_relation.update(status: params[:status])
        render json: { status: :ok }
      else
        render json: { status: :unprocessable_entity }
      end
    else
      candidate = Candidate.find(params[:candidate_id])
        if staff_relation.delete
          candidate.update(status: 'Пассивен')
        end
      render json: { status: :ok, candidate: candidate }
    end
  end

  def mark_candidates_as_found
    found_status = 'Найденные'
    @marked_as_found_candidates = Candidate.where('id IN (?)', params[:candidates_ids])
    vacancy = Vacancy.find(params[:id])
    @marked_as_found_candidates.each do |candidate|
      candidate.update(status: 'В работе')
      StaffRelation.create(candidate_id: candidate.id, vacancy_id: vacancy.id, status: found_status)
    end

    found_candidates = vacancy.candidates_with_status(found_status)

    render json: build_response_hash(found_candidates,
                                     StaffRelation::STATUSES,
                                     vacancy.id,
                                     found_status)
  end

  private
    def vacancy_params
      params.require(:vacancy).permit(
        :name, :salary,
        :salary_format,
        :languages, :status,
        :requirements, :region_id
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
