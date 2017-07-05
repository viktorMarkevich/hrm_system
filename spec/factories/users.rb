FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "email#{n}@ukr.net" }
    sequence(:skype) { |n| "faceit_skype#{n}" }
    password 'password'
    password_confirmation'password'
    first_name 'Bob'
    last_name 'Marly'
    post 'Директор'
    sequence(:phone) { |n| "+38-050-000-000#{n}" }
    region Region::REGIONS.sample

    factory :user_with_events do
      transient do
        events_count 5
      end
      after(:create) do |user, evaluator|
        create_list(:event, evaluator.events_count, user_id: user.id, staff_relation_id: 1)
      end
    end
  end

  factory :invalid_user, parent: :user do
    email nil
  end

end