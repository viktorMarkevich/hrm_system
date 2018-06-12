# coding: utf-8
FactoryBot.define do

  factory :vacancy do
    sequence(:name) { |n| "Вакансия_#{n}" }
    salary '550'
    salary_format 'usd'
    status 'Не задействована'
    languages 'Английский, Русский'
    requirements 'Ответственный'
    region Region::REGIONS.sample
    association :owner, factory: :user
  end

  factory :invalid_vacancy, parent: :vacancy do
    name nil
    salary nil
    salary_format nil
    status nil
    languages nil
    requirements nil
  end

  factory :deleted_vacancy, parent: :vacancy do
    deleted_at Time.now
    status 'Закрыта'
  end

end