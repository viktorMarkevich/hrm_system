FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@ukr.net" }
    password 'password'
    password_confirmation'password'
    first_name 'Bob'
    last_name 'Marly'
    post 'Author'
  end

  factory :invalid_user, parent: :user do
    email nil
  end
end
