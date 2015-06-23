FactoryGirl.define do
  factory :company do |obj|
    obj.sequence(:name) { |n| "Company#{n}" }
    obj.url 'http://www.mycompany.com.ua'
    obj.region_id 1
    obj.description 'В процессе'
  end
end