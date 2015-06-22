# coding: utf-8

FactoryGirl.define do
  factory :vacancy do |obj|
    obj.sequence(:name) { |n| "Вакансия#{n}" }
    obj.salary '550'
    obj.salary_format  'usd'
    obj.region_id 1
    obj.status 'В процессе'
    obj.languages 'Английский, Русский'
    obj.requirements 'Ответственный'
  end
end