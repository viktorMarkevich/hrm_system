class StaffRelationsController < ApplicationController

  def new
    @vacancy = Vacancy.find(params[:vacancy_id]) || Vacancy.only_deleted.where( id: params[:vacancy_id])
    @staff_relation = StaffRelation.new

    @all_candidates = Candidate.includes([:staff_relations, :vacancies])
    @current_candidates = @all_candidates.where(staff_relations: { vacancy_id: @vacancy.id })
    @candidates = @all_candidates - @current_candidates
  end

  def create
    begin
      st_params[:candidate_id].each do |id|
        StaffRelation.create(st_params.merge!(candidate_id: id))
      end
      @vacancy = Vacancy.find(st_params[:vacancy_id])
      @vacancy_candidates = @vacancy.candidates_with_status('Найденные')

      respond_to do |format|
        format.html { render nothing: true }
        format.js
      end
    rescue Exception => error
      puts "I've see this error #{error}"
    end
  end

  def destroy
    sr = StaffRelation.where(candidate_id: params[:candidate_id],
                             vacancy_id: params[:vacancy_id] ).first
    sr.delete
    redirect_to :back
  end

  private

  def st_params
    params.require(:staff_relation).permit(:status, :notice, :vacancy_id, candidate_id: [] )
  end
end
