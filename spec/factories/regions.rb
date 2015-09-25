FactoryGirl.define do
  factory :region do
    sequence(:name) { |n| "region#{n}" }
  end
end