FactoryBot.define do

  factory :company do
    sequence(:name) { |n| "Компания#{n}" }
    url 'http://www.mycompany.com.ua'
    description 'В процессе'
    region Region::REGIONS.sample
  end

end