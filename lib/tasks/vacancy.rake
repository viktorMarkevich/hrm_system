desc 'Add user_id Vacancy'
task vacancies: :environment do
  # region = User.first.present? ? Region.first : Region.create(name: 'Херсон')
  User.create!(email: 'zzz@zzz.zzz', password: 'zzzzzz', password_confirmation: 'zzzzzz', first_name: 'zzz',
                                                         last_name: 'zzz', post: 'zzz', region_id: region.id)

  # Vacancy.find_each do |vacancy|
  #   vacancy.update(user_id: user.id)
  # end
end