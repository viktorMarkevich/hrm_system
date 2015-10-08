class CandidatesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_candidate, only: [:show, :edit, :update]
  before_filter :set_companies, only: [:new, :edit]

  def index
    @candidates = Candidate.includes(:owner).order('id').page(params[:page]).per(10)
    @candidates = @candidates.where('company_id = ?', params[:company_id]) if params[:company_id]
  end

  def new
    @candidate = Candidate.new
    @vacancies = Vacancy.all
  end

  def show
  end

  def edit
    @vacancy = @candidate.vacancies.first
    @vacancies = Vacancy.where.not(id: @vacancy)
  end

  def create
    if (vacancy_id = params[:candidate][:desired_position]).present?
      params[:candidate].update(desired_position: Vacancy.find(vacancy_id).name, status: Candidate::STATUSES[1])
      @candidate = current_user.candidates.build(candidate_params)
      @candidate.staff_relations.build(status: 'Найденные', vacancy_id: vacancy_id)
    end
    if @candidate.save!
      flash[:success] = 'Кандидат был успешно добавлен.'
      redirect_to candidates_path
    else
      flash[:error] = 'Неее братан. Лажа какая-то! Не, точно нет!'
      redirect_to new_candidate_path
    end
  end

  def update
    if (vacancy_id = params[:candidate][:desired_position]).present?
      params[:candidate].update(desired_position: Vacancy.find(vacancy_id).name)
    end

    if @candidate.update(candidate_params)
      flash[:notice] = 'Запись успешно обновлена.'
      redirect_to candidates_path
    else
      render 'edit'
    end
  end

  private

    def set_companies
      @companies = Company.get_company_name
    end

    def candidate_params
      params.require(:candidate).permit(
          :name, :birthday, :salary, :salary_format, :notice,
          :education, :languages, :city_of_residence, :company_id,
          :ready_to_relocate, :desired_position, :experience,
          :status, :source, :description, :email, :phone, :linkedin,
          :facebook, :vkontakte, :google_plus, :full_info, :skype, :home_page
      )
    end

    def find_candidate
      @candidate = Candidate.find(params[:id])
    end

end
