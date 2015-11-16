# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Vacancy.delete_all
Candidate.delete_all
Company.delete_all
Region.delete_all
StaffRelation.delete_all
Event.delete_all

Region.create(name: Region::REGIONS[0])

for i in 1..10 do
  Vacancy.create(
    name: 'Программист руби' + i.to_s,
    salary: '500',
    salary_format: 'USD',
    status: 'Не задействована',
    region_id: Region.first.id,
    user_id: User.first.id
  )
end

for i in 1..10 do
  Candidate.create(
      name: 'Тирион Ланистер' + i.to_s,
      desired_position: 'Программист, язык руби',
      city_of_residence: 'Запорожье',
      salary: '300-500 USD',
      status: 'В работе'
  )
end

for i in  1..15 do
  Company.create(
      name: 'veloonline' + i.to_s,
      region_id: Region.first.id,
      url: 'http://www.veloonline.com/view.shtml?id=8933',
      description: 'Купить Шатуны Shimano FC-M361 ACERA 48/38/28 по хорошей цене в интернет-магазине VeloOnline.com, мы предлагаем широкий ассортимент Shimano и привлекательные цены на Шатуны для велосипеда.'
  )
end