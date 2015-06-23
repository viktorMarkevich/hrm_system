FactoryGirl.define do
  factory :region do |obj|
    obj.sequence(:name) { |n| "region#{n}"}
  end
end