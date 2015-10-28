FactoryGirl.define do
  factory :event do
    name 'Name'
    will_begin_at { rand((Time.zone.now + 1.hours)..(Time.zone.now.end_of_month)) }
    description 'описание события'
    user
  end

  factory :invalid_event, parent: :event do
    name nil
    description nil
    will_begin_at Time.zone.now - 1.hours
  end

  factory :deleted_event, parent: :event do
    deleted_at Time.zone.now
  end

end
