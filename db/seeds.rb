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

for i in 1..10 do
  Vacancy.create(
    name: 'Программист руби',
    salary: '500',
    salary_format: 'USD',
    status: 'В процессе',
    region_id: 1,
    user_id: 1
  )
end

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
      region_id: 1,
      url: 'http://www.veloonline.com/view.shtml?id=8933',
      description: 'Купить Шатуны Shimano FC-M361 ACERA 48/38/28 по хорошей цене в интернет-магазине VeloOnline.com,
                    мы предлагаем широкий ассортимент Shimano и привлекательные цены на Шатуны для велосипеда.'
  )
end

vacancies_ids = Vacancy.pluck(:id)
candidates_ids = Candidate.pluck(:id)

candidates_count = candidates_ids.count
vacancies_count = vacancies_ids.count

found_status = StaffRelation::STATUSES[0]

for i in 0..vacancies_ids.count do
  rand_vacancy_id = vacancies_ids[rand(0..vacancies_count - 1)]
  rand_candidate_id = candidates_ids[rand(0..candidates_count - 1)]
  StaffRelation.create(status: found_status, vacancy_id: rand_vacancy_id, candidate_id: rand_candidate_id)
end