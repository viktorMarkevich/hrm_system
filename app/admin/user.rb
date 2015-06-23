ActiveAdmin.register User do

  permit_params :password, :password_confirmation, :first_name, :last_name, :email, :skype, :phone, :post, :avatar

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :skype
    column :phone
    column :post
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
      f.input :skype
      f.input :phone
      f.input :avatar
    end
    f.actions
  end
end
