FactoryGirl.define do
  factory :event do
    name 'Name'
    starts_at DateTime.now+1.hours
    description 'описание события'
  end

  factory :invalid_event, parent: :event do
    name nil
    description nil
  end

  factory :deleted_event, parent: :event do
    deleted_at DateTime.now
  end
end