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
    region
  end

  factory :invalid_user, parent: :user do
    email nil
  end
end
