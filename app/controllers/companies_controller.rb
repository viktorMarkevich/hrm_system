class CompaniesController < ApplicationController
  include RegionSupporter

  before_filter :authenticate_user!
  before_action :find_company, only: [:edit, :update, :show]


  def index
    @companies = Company.order('created_at DESC').page(params[:page]).per(10)
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
    @company.associate_with_region(params[:region])
    if @company.save
      flash[:notice] = 'Компания была успешно создана.'
      redirect_to companies_path
    else
      render 'new'
    end
  end

  def update
    @company.associate_with_region(params[:region])
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
    params.require(:company).permit(:name, :region_id, :url, :description)
  end

end
