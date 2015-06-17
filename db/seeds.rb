# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
vacancies = ['Программист, язык ruby', 'Программист, язык php']
regions = ['Запорожье', 'Львов']
for i in  1..15 do
  Vacancy.create(
      name: vacancies[rand(1)],
      region: regions[rand(1)],
      salary: '300-350',
      languages: 'Английский',
      status: 'В процессе'
  )
end