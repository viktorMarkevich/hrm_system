class StaffRelationsController < ApplicationController

  def create
    puts '***********************************************************'
    params[:candidates_ids].each do |candidate|
      StaffRelation.create(status: 'Найденные', vacancy_id: params[:vacancy_id].to_i, candidate_id: candidate.to_i)
    end
    redirect_to vacancy_path(params[:vacancy_id].to_i, status: 'Найденные')
  end

end
