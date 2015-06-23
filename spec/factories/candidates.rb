FactoryGirl.define do
  factory :candidate do |obj|
    obj.sequence(:name) { |n| "test_user#{n}" }
    obj.birthday '2015-06-12'
    obj.salary '450'
    obj.salary_format 'usd'
    obj.education 'Oxford'
    obj.languages 'Английский, Русский'
    obj.ready_to_relocate 'yes'
    obj.desired_position 'Программист, руби'
    obj.experience '3 года'
    obj.status 'В процессе'
    obj.sequence(:email) { |n| "#{n}email@mail.ru" }
    obj.sequence(:phone) { |n| "+3805000000#{n+10}" }
    obj.linkedin 'linkedin'
    obj.facebook 'facebook'
    obj.vkontakte 'vkontakte'
    obj.google_plus 'Google+'
  end
end