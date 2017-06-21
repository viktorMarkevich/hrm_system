FactoryGirl.define do
  factory :history do
    association :history, factory: :staff_relation
  end
  factory :invalid_history_event, parent: :history do
    historyable_type nil
    historyable_id nil
  end
end