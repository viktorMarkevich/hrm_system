ActiveAdmin.register User do
  include RegionSupporter

  permit_params :first_name, :last_name, :email, :post, :region_id

  actions :all

  collection_action :send_invitation, method: :post do
    region = Region.find_or_create(params[:region])
    @user = User.invite!(permitted_params[:user])
    region.users << @user
    if @user.valid? && @user.errors.empty?
      flash[:notice] = 'User has been successfully invited.'
      redirect_to admin_users_path
    else
      flash[:error] = 'is invalid'
      render 'new'
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :skype
    column :phone
    column :post
    column :region_id
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'User Details' do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :post
      f.input :region, as: :select, collection: Region::NAMES, selected: resource.region_name, input_html: { name: 'region' }
    end
    f.actions
  end

  controller do
    def new
      @user = User.new
      render 'new', layout: 'active_admin'
    end
  end

  controller do

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(permitted_params[:user])
        region = Region.find_or_create(params[:region])
        region.users << @user

        flash[:notice] = 'Пользователь успешно обновлен.'
        redirect_to admin_user_path(@user)
      else
        render 'edit'
      end
    end

  end
end
