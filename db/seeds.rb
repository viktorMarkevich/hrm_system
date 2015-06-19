# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#vacancies = ['Программист, язык ruby', 'Программист, язык php']
regions = ['Запорожье', 'Львов']
#for i in  1..15 do
#  Vacancy.create(
#      name: vacancies[rand(1)],
#      region: regions[rand(1)],
#      salary: '300-350',
#      languages: 'Английский',
#      status: 'В процессе'
#  )
#end

for i in 1..10 do
  Candidate.create(
      name: 'Тирион Ланистер',
      desired_position: 'Программист, язык руби',
      city_of_residence: 'Запорожье',
      salary: '300-500 USD',
      status: 'в процессе'
  )
end

for i in  1..15 do
  Company.create(
      name: 'veloonline',
      region: regions[rand(1)],
      url: 'http://www.veloonline.com/view.shtml?id=8933',
      description: 'Купить Шатуны Shimano FC-M361 ACERA 48/38/28 по хорошей цене в интернет-магазине VeloOnline.com,
                    мы предлагаем широкий ассортимент Shimano и привлекательные цены на Шатуны для велосипеда.'
  )
end