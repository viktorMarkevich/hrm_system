class CompaniesController < ApplicationController

  before_filter :authenticate_user!
  before_action :find_company, only: [:edit, :update, :show]


  def index
    @companies = Company.all.order('created_at DESC')
  end

  def new
    @company = Company.new
  end

  def show
  end

  def edit
  end

  def create
    region = Region.find_or_create(params[:region])
    @company = region.assign_company(company_params)

    if @company.save
      flash[:notice] = 'Компания была успешно создана.'
      redirect_to companies_path
    else
      render 'new'
    end
  end

  def update
    if @company.update_attributes(company_params)
      region = Region.find_or_create(params[:region])
      region.companies << @company

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
    params.require(:company).permit(:name, :region_id, :url, :description)
  end

end
