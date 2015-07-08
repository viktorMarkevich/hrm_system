# coding: utf-8

FactoryGirl.define do
  factory :vacancy do
    sequence(:name) { |n| "Вакансия#{n}" }
    salary '550'
    salary_format 'usd'
    status 'В процессе'
    languages 'Английский, Русский'
    requirements 'Ответственный'
    region
    association :owner, factory: :user
  end
end