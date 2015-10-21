FactoryGirl.define do
  factory :event do
    name 'Name'
    will_begin_at { rand((DateTime.now + 1.hours)..DateTime.now.next_week) }
    description 'описание события'
    user
  end

  factory :invalid_event, parent: :event do
    name nil
    description nil
  end

  factory :deleted_event, parent: :event do
    deleted_at DateTime.now
  end
end