FactoryGirl.define do
  factory :staff_relation do
    status 'Найденные'
    notice 'Примечание'
    association :candidate
    association :vacancy
  end
end