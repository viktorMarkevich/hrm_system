# coding: utf-8

FactoryGirl.define do
  factory :vacancy do
    sequence(:name) { |n| "Вакансия#{n}" }
    salary '550'
    salary_format  'usd'
    region 'Запорожье'
    status 'В процессе'
    languages 'Английский, Русский'
    requirements 'Ответственный'
  end
end