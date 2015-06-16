FactoryGirl.define do
  factory :sticker do |obj|
    obj.sequence(:title) { |n| "sticker#{n} title" }
    obj.description 'Default description'
  end
end