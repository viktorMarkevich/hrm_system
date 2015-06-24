ActiveAdmin.register User do

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
      f.input :password, input_html: { value: '12345678' }, as: :hidden
      f.input :password_confirmation, input_html: { value: '12345678' }, as: :hidden
      f.input :first_name
      f.input :last_name
      f.input :post
      f.select(:region_id,  options_for_select(Region.all.map{ |r| [r.name, r.id] }), {})
      f.input :skype
      f.input :phone
      f.input :avatar
    end
    f.actions
  end
end
