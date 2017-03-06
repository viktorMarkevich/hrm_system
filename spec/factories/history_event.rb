FactoryGirl.define do
  factory :history_event do
    # status 'Найденные'
    old_status 'Примечание'
    new_status 'Примечание'
    user
    association :history_eventable, factory: :staff_relation
  end
end