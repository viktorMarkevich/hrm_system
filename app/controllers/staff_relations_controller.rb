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
      Vacancy.update_status(st_params[:vacancy_id])
      candidates_ids.each do |id|
        StaffRelation.create(st_params.merge!(status: 'Найденные', candidate_id: id))
      end
      redirect_to vacancy_path(id: st_params[:vacancy_id])
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
    params.require(:staff_relation).permit(:status, :notice, :vacancy_id, candidate_id: [])
  end

  def candidates_ids
    params[:staff_relation][:candidate_id].map{|k, v| k if v == '1'}.compact
  end

end
