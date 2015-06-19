FactoryGirl.define do
  factory :company do |obj|
    obj.sequence(:name) { |n| "Компания#{n}" }
    obj.url 'vkontakte.com.ua'
    obj.region 'Запорожье'
    obj.description 'В процессе'
  end
end