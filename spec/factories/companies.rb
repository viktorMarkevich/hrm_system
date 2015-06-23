FactoryGirl.define do
  factory :company do
    sequence(:name) { |n| "Company#{n}" }
    url 'http://www.mycompany.com.ua'
    region_id 1
    description 'В процессе'
  end
end