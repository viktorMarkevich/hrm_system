# coding 'utf-8'
class CandidatesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_candidate, only: [ :show, :edit, :update, :set_vacancies, :update_resume ]
  before_action :set_companies, only: [ :new, :edit ]

  def index
    @status = params[:status]
    if params[:tags]
      @candidates = Candidate.preload(:owner).tagged_with(params[:tags], any: true).where('name ILIKE ?', "%#{params[:term]}%")
                             .page(params[:page]).per(10)
    else
      @candidates = Candidate.preload(:owner).where(filter_condition).order('id').page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html
      format.js
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
    @staff_relations = @candidate.staff_relations
    @vacancies = Vacancy.where.not(id: @staff_relations.pluck(:vacancy_id))
  end

  def edit
  end

  def create
    CvSource.find_or_create_by(name: candidate_params[:source])
    @candidate = current_user.candidates.build(candidate_params)
    if @candidate.save
      @candidate.reload
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
      @staff_relation = @candidate.staff_relations.new(status: 'Найденные', vacancy_id: params[:vacancy_id])
      if @staff_relation.save
        @vacancy = Vacancy.find(params[:vacancy_id])
        respond_to { |format| format.json }
      else
        respond_to do |format|
          format.json { render status: :unprocessable_entity }
        end
      end
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

  def update_resume
    respond_to do |format|
      format.html
      format.json do
        if @candidate.update(original_cv_data: params[:original_cv_data])
          render json: {}
        end
      end
    end
  end

  private
  def set_companies
    @companies = Company.get_company_name
  end

  def candidate_params
    params.require(:candidate).permit(:name, :birthday, :salary, :salary_format, :notice, :education, :languages,
                                      :city_of_residence, :ready_to_relocate, :desired_position, :status, :source,
                                      :description, :email, :phone, :linkedin, :facebook, :vkontakte, :google_plus,
                                      :full_info, :skype, :home_page, :file_name, :tag_list, :company_ids)
  end

  def find_candidate
    @candidate = Candidate.find(params[:id])
  end

  def filter_condition
    params.permit(:company_id, :status)
  end

end