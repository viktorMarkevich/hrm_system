class StaffRelationsController < ApplicationController

  # skip_before_filter :verify_authenticity_token
  # before_action :authenticate_user!
  include VacancyHelper

  def new
    @vacancy = Vacancy.find(params[:vacancy_id]) || Vacancy.only_deleted.where(id: params[:vacancy_id])
    @staff_relation = StaffRelation.new

    @all_candidates = Candidate.includes([:staff_relations, :vacancies])
    @current_candidates = @all_candidates.where(staff_relations: { vacancy_id: @vacancy.id })
    @candidates = @all_candidates - @current_candidates
    respond_to do |format|
      format.json
    end
  end

  def create
    @vacancy = Vacancy.find(st_params[:vacancy_id])
    @vacancy.candidates << Candidate.where(id: st_params[:candidate_id])
    @vacancy.update_attributes(status: 'В работе')
    @vacancy_candidates = @vacancy.candidates_with_status('Найденные')
    @vacancy_status_class = get_label_class(@vacancy)
    respond_to do |format|
      format.html { head :ok }
      format.js
      format.json
    end
  end

  def destroy
    staff_relation = StaffRelation.find(params[:id])
    vacancy = staff_relation.vacancy
    candidate = staff_relation.candidate
    staff_relation.delete
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { vacancy_id: vacancy.id, vacancy_name: vacancy.name, candidate_id: candidate.id } }
    end
  end

  private
  def st_params
    params.require(:staff_relation).permit(:status, :notice, :vacancy_id, candidate_id: [])
  end

end
