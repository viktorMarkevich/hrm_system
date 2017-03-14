# coding 'utf-8'
class CandidatesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_candidate, only: [:show, :edit, :update, :set_vacancies]
  before_action :set_companies, only: [:new, :edit]

  def index
    if request.format != 'text/html' && !params[:page].present?
      @candidates = Candidate.includes(:owner).order('id')
    else
      @candidates = Candidate.includes(:owner).order('id').page(params[:page]).per(10)
    end
    @candidates = @candidates.where('company_id = ?', params[:company_id]) if params[:company_id]
    respond_to do |format|
      format.html
      format.csv { send_data @candidates.to_csv, filename: "candidates-#{Date.today}.csv" }
      format.pdf do
        pdf = CandidatesPdf.new(@candidates)
        send_data pdf.render, filename: "candidates-#{Date.today}.xlsx", type: 'application/pdf'
      end
      format.xlsx do
         response.headers['Content-Disposition'] = "attachment; filename=candidates-#{Date.today}.xlsx"
      end
    end
  end

  def new
    @candidate = Candidate.new
  end

  def show
    @candidate_vacancies = @candidate.vacancies.includes(:staff_relations)
    @vacancies = Vacancy.where.not(id: @candidate_vacancies.pluck(:id))
  end

  def edit
  end

  def create
    CvSource.find_or_create_by(name: candidate_params[:source])
    @candidate = current_user.candidates.build(candidate_params)
    if @candidate.save!
      flash[:success] = 'Кандидат был успешно добавлен.'
      redirect_to candidates_path
    else
      flash[:error] = 'Неее братан. Лажа какая-то! Не, точно нет!'
      redirect_to new_candidate_path
    end
  end

  def update
    if @candidate.update(candidate_params)
      flash[:notice] = 'Запись успешно обновлена.'
      redirect_to candidate_path(@candidate)
    else
      render 'edit'
    end
  end

  def set_vacancies
    if params[:vacancy_id].present?
      @candidate.staff_relations.create(status: 'Найденные', vacancy_id: params[:vacancy_id])
    end
    @candidate_vacancies = @candidate.vacancies.includes(:staff_relations)
    @vacancies = Vacancy.where.not(id: @candidate_vacancies.pluck(:id))

    respond_to do |format|
      format.js
    end
  end

  def upload_resume
    begin
      @candidate = current_user.candidates.build
      @candidate.save_resume_to_candidate(params[:upload_resume][:file])
      flash[:notice] = 'Данные сохранились успешно'
      redirect_to edit_candidate_path(@candidate)
    rescue Exception => error
      flash[:error] = "I've see this error #{error}"
      redirect_to new_candidate_path
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
          :ready_to_relocate, :desired_position, :status, :source,
          :description, :email, :phone, :linkedin, :facebook,
          :vkontakte, :google_plus, :full_info, :skype, :home_page, :file_name
      )
    end

    def find_candidate
      @candidate = Candidate.find(params[:id])
    end

end
