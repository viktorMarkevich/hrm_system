FactoryBot.define do

  factory :history do
  end

  factory :invalid_history_event, parent: :history do
    historyable_type nil
    historyable_id nil
  end

end