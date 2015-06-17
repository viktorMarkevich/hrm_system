FactoryGirl.define do
  factory :sticker do |obj|
    obj.sequence(:title) { |n| "sticker#{n} title" }
    obj.description 'Default description'
  end

  factory :invalid_sticker, parent: :sticker do |f|
    f.title nil
  end
end