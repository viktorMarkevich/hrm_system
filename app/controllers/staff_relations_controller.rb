class StaffRelationsController < ApplicationController

  def new
    @staff_relation = StaffRelation.new
    @vacancy = Vacancy.find(params[:vacancy_id])

    @all_candidates = Candidate.includes(:staff_relations)
    @current_candidates = @all_candidates.where(staff_relations: { vacancy_id: @vacancy.id })
    @candidates = @all_candidates - @current_candidates
  end

  def create
    params[:candidates_ids].each do |candidate|
      StaffRelation.find_or_create_by(status: 'Найденные', vacancy_id: params[:vacancy_id].to_i, candidate_id: candidate.to_i)
    end
    redirect_to vacancy_path(params[:vacancy_id].to_i)
  end

end
