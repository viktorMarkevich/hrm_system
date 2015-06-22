FactoryGirl.define do
  factory :candidate do
    sequence(:name) { |n| "test_user#{n}" }
    birthday '2015-06-12'
    salary '450'
    salary_format 'usd'
    education 'Oxford'
    languages 'Английский, Русский'
    ready_to_relocate 'yes'
    desired_position 'Программист, руби'
    experience '3 года'
    status 'В процессе'
    sequence(:email) { |n| "email#{n}" }
    sequence(:phone) { |n| "+ 3 8 050 000 00#{n}" }
    linkedin 'linkedin'
    facebook 'facebook'
    vkontakte 'vkontakte'
    google_plus 'Google+'
  end
end