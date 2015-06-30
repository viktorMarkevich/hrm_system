ActiveAdmin.register User do
  include RegionSupporter

  permit_params :password, :password_confirmation, :first_name, :last_name, :email, :skype, :phone, :post, :avatar, :region_id

  actions :all

  collection_action :send_invitation, method: :post do
    @user = User.invite!(permitted_params[:user])
    if @user.valid? && @user.errors.empty?
      flash[:notice] = 'User has been successfully invited.'
      redirect_to admin_users_path
    else
      flash[:error] = 'is invalid'
      redirect_to new_admin_user_path
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
    column :region_id do |user| user.region.name end
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

    def create
      region = Region.find_or_create(params[:region])
      @user = region.build_user(user_params)

      if @user.save
        flash[:notice] = 'Пользователь успешно создан.'
        redirect_to admin_users_path
      else
        render 'new'
      end
    end

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        region = Region.find_or_create(params[:region])
        region.users << @user

        flash[:notice] = 'Пользователь успешно обновлен.'
        redirect_to admin_user_path(@user)
      else
        render 'edit'
      end
    end

    def user_params
      params.require(:user).permit(
          :first_name, :last_name,
          :post, :email,
          :skype, :phone,
          :avatar, :region_id,
          :password, :password_confirmation
      )
    end

  end
end