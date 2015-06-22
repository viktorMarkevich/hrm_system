FactoryGirl.define do
  factory :company do
    sequence(:name) { |n| "Компания#{n}" }
    url 'vkontakte.com.ua'
    region 'Запорожье'
    description 'В процессе'
  end
end