class CompaniesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_company, only: [:edit, :update, :show]


  def index
    @companies = Company.includes([ :candidates, :owner ]).order('id').page(params[:page]).per(10)
  end

  def new
    @company = Company.new
  end

  def show
  end

  def edit
  end

  def create
    @company = current_user.companies.build(company_params)
    if @company.save
      flash[:notice] = 'Компания была успешно создана.'
      redirect_to companies_path
    else
      render 'new'
    end
  end

  def update
    if @company.update_attributes(company_params)
      flash[:notice] = 'Компания успешно обновлена.'
      redirect_to company_path(@company)
    else
      render 'edit'
    end
  end

  private
  def find_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :region, :url, :description)
  end

end