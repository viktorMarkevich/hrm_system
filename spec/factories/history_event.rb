FactoryGirl.define do
  factory :history_event do
    # status 'Найденные'
    old_status 'Примечание'
    new_status 'Примечание'
    user
    association :history_eventable, factory: :staff_relation
  end
  factory :invalid_history_event, parent: :history_event do
    history_eventable_type nil
    history_eventable_id nil
  end
end