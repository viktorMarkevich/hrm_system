desc 'Add user_id Vacancy'
task vacancies: :environment do
  region = Region.first_or_create(name: 'Херсон')
  user = User.first_or_create(email: 'test1@test.ts', password: '123456',
                             password_confirmation: '123456', first_name: 'test1',
                             last_name: 'test1', post: 'test1', region_id: region)

  Vacancy.update_all(user_id: user, region: region)
end