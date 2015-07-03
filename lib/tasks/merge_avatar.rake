namespace :merge_avatar do

  desc 'Add object image for each user'
  task add_object_img: :environment do
    User.all.each do |user|
      Image.create(user_id: user.id)
    end
  end

end
