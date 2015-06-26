ActiveAdmin.register User do
  include RegionSupporter

  permit_params :password, :password_confirmation, :first_name, :last_name, :email, :skype, :phone, :post, :avatar, :region_id

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
      f.input :password, input_html: { value: '123456' }, as: :hidden
      f.input :password_confirmation, input_html: { value: '123456' }, as: :hidden
      f.input :first_name
      f.input :last_name
      f.input :post
      f.input :region, as: :select, collection: Region::NAMES, selected: resource.region_name, input_html: { name: 'region' }
      f.input :skype
      f.input :phone
      f.input :avatar
    end
    f.actions
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
