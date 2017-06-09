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
StaffRelation.delete_all
Event.delete_all
User.delete_all
History.delete_all

User.create!([ { first_name: 'User',
                 last_name: 'Test',
                 email: 'user@mail.com',
                 phone: '0811111111',
                 skype: 'usertest',
                 password: '123456',
                 post: 'test',
                 region: Region::REGIONS.first,
                 reset_password_token: nil,
                 reset_password_sent_at: nil,
                 remember_created_at: nil, } ])

for i in 1..10 do
  Vacancy.create( name: 'Программист руби' + i.to_s,
                  salary: '500',
                  salary_format: 'USD',
                  status: 'Не задействована',
                  region: Region::REGIONS.first,
                  user_id: User.first.id )
end

for i in 1..15 do
  Candidate.create!( name: 'Тирион Ланистер' + i.to_s,
                     desired_position: 'Программист, язык руби',
                     city_of_residence: 'Запорожье',
                     salary: '300-500 USD',
                     status: 'В работе',
                     email: "user#{i}@mail.com",
                     phone: "081111111#{i+1}",
                     skype: "usertes#{i}",
                     source: "Имяфайла#{i}.docx",
                     user_id: User.first.id )
end

for i in 16..30 do
  Candidate.create!( name: 'Тирион Ланистер' + i.to_s,
                     desired_position: 'Программист, язык руби',
                     city_of_residence: 'Запорожье',
                     salary: '300-500 USD',
                     status: 'Пассивен',
                     email: "user#{i+1}@mail.com",
                     phone: "081111111#{i+1}",
                     skype: "usertes#{i}",
                     source: "Имяфайла#{i}.docx",
                     user_id: User.first.id )
end

for i in  1..15 do
  Company.create( name: 'veloonline' + i.to_s,
                  region: Region::REGIONS.first,
                  url: 'http://www.veloonline.com/view.shtml?id=8933',
                  description: 'Купить Шатуны Shimano FC-M361 ACERA 48/38/28 по хорошей цене в интернет-магазине VeloOnline.com, мы предлагаем широкий ассортимент Shimano и привлекательные цены на Шатуны для велосипеда.')
end