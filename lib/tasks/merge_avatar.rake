desc 'Add object image for each user'
task add_object_img: :environment do
  User.all.each do |user|
    Image.create(user_id: user) unless user.image
  end
end
