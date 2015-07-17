FactoryGirl.define do
  factory :event do
    name 'Name'
    starts_at '2015-10-15 12:12'
  end

  factory :invalid_event, parent: :event do
    name nil
  end

  factory :deleted_event, parent: :event do
    deleted_at DateTime.now
  end
end