FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@ukr.net" }
    sequence(:skype) { |n| "faceit_skype#{n}" }
    password 'password'
    password_confirmation'password'
    first_name 'Bob'
    last_name 'Marly'
    post 'Author'
    region_id 1
  end

  factory :invalid_user, parent: :user do
    email nil
  end
end
