FactoryGirl.define do
  factory :sticker do
    sequence(:title) { |n| "sticker#{n} title" }
    description 'Default description'
  end

  factory :invalid_sticker, parent: :sticker do
    title nil
  end
end