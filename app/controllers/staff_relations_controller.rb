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
       @st = StaffRelation.create(st_params.merge!(candidate_id: id))
      end
      @vacancy = Vacancy.find(st_params[:vacancy_id])
      @vacancy_candidates = @vacancy.candidates_with_status('Найденные')
      history_event = @st.history_events.create(user_id: current_user.id, old_status: 'Пасивен', new_status: 'Найденные' )

      respond_to do |format|
        format.html { head :ok }
        format.js
      end
    rescue Exception => error
      puts "I've see this error #{error}"
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
    params.require(:staff_relation).permit(:status, :notice, :vacancy_id, candidate_id: [] )
  end
end
