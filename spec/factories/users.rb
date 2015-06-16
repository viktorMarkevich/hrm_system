FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@ukr.net" }
    sequence(:password) { |n| 'password' }
    sequence(:password_confirmation) { |n| 'password' }
  end
end
