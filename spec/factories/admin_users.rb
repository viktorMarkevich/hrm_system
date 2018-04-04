FactoryBot.define do

  factory :admin_user do
    sequence(:email) { |n| "email#{n}@ukr.net" }
    password 'password'
    password_confirmation'password'
  end

  factory :invalid_admin_user, parent: :user do |f|
    f.email nil
  end

end
