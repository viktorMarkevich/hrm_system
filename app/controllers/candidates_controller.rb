class CandidatesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_candidate, only: [:show, :edit, :update]

  def index
    @candidates = Candidate.includes(:owner).order('id').page(params[:page]).per(10)
  end

  def new
    @candidate = Candidate.new
  end

  def show
  end

  def edit
  end

  def create
    @candidate = current_user.candidates.build(candidate_params)
    if @candidate.save
      StaffRelation.create(candidate_id: @candidate.id)
      flash[:notice] = 'Кандидат был успешно добавлен.'
      redirect_to candidates_path
    else
      render 'new'
    end
  end

  def update
    if @candidate.update(candidate_params)
      flash[:notice] = 'Запись успешно обновлена.'
      redirect_to candidates_path
    else
      render 'edit'
    end
  end

  private

    def candidate_params
      params.require(:candidate).permit(
          :name, :birthday, :salary, :salary_format,
          :education, :languages, :city_of_residence,
          :ready_to_relocate, :desired_position, :experience,
          :status, :source, :description, :email, :phone, :linkedin,
          :facebook, :vkontakte, :google_plus, :full_info, :skype, :home_page
      )
    end

    def find_candidate
      @candidate = Candidate.find(params[:id])
    end

end
