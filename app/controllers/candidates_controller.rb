class CandidatesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_candidate, only: [:show, :edit, :update]

  def new
    @candidate = Candidate.new
  end

  def create
    @candidate = Candidate.new(candidate_params)
    if @candidate.save
      flash[:notice] = 'Кандидат был успешно добавлен.'
      redirect_to candidates_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @candidate.update(candidate_params)
      flash[:notice] = 'Запись успешно обновлена.'
      redirect_to candidates_path
    else
      render 'edit'
    end
  end

  def index
    @candidates = Candidate.all
  end

  def show

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

    def get_candidate
      @candidate = Candidate.find(params[:id])
    end
end
