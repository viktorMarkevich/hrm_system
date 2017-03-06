FactoryGirl.define do
  factory :candidate do
    sequence(:name) { |n| "test_user#{n}" }
    birthday '06-12-2015'
    salary '450'
    salary_format 'usd'
    education 'Oxford'
    languages 'Английский, Русский'
    ready_to_relocate 'yes'
    desired_position 'Программист, руби'
    status 'Пассивен'
    sequence(:skype) { |n| "skype_login#{n}" }
    sequence(:email) { |n| "#{n}email@mail.ru" }
    sequence(:phone) { |n| "+38-050-000-000#{n}" }
    linkedin 'https://ua.linkedin.com/pub/test-user/9a/29/644'
    facebook 'http://www.facebook.com/test.user'
    vkontakte 'http://vk.com/test_man'
    google_plus 'https://plus.google.com/u/0/109854654'
    association :owner, factory: :user
    sequence(:source) { |n| "CV_ENG.docx#{n}" }
    city_of_residence 'Киев'
  end
end