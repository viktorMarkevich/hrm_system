FactoryGirl.define do
  factory :cv_source do
    sequence(:name) { |n| "source#{n}" }
  end
end