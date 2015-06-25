ActiveAdmin.register User do

  permit_params :password, :password_confirmation, :first_name, :last_name, :email, :skype, :phone, :post, :avatar, :region_id

  actions :all

  action_item do
    link_to 'Invite New User', new_invitation_admin_users_path
  end

  collection_action :new_invitation do
    @user = User.new
  end

  collection_action :send_invitation, :method => :post do
    @user = User.invite!(permitted_params[:user])
    if @user.errors.empty?
      flash[:success] = "User has been successfully invited."
      redirect_to admin_users_path
    else
      flash[:error] = "Invitation sending error occured"
      redirect_to new_invitation_admin_users_path
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
      f.input :password, input_html: { value: '123456' }, as: :hidden
      f.input :password_confirmation, input_html: { value: '123456' }, as: :hidden
      f.input :first_name
      f.input :last_name
      f.input :post
      f.label :region_id
      f.select(:region_id,  options_for_select(Region.all.map{ |r| [r.name, r.id] }, user.region_id), {})
      f.input :skype
      f.input :phone
      f.input :avatar
    end
    f.actions
  end
end
