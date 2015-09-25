FactoryGirl.define do
  factory :staff_relation do
    status 'Найденные'
    notice 'Примечание'
    association :candidate
    association :vacancy
    association :event
  end
end