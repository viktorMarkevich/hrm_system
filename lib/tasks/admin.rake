namespace :admin do
  desc 'update admin'
  task update_admin: :environment do
    AdminUser.all.each do |a|
      p '*' *100
      p a.email
      p '*' *100

      a.update_attributes(password: '123456', password_confirmation: '123456')
    end
  end
end