FactoryGirl.define do
  factory :sticker do
    description 'Default description'
    association :owner, factory: :user
  end

  factory :invalid_sticker, parent: :sticker do
    description nil
  end

  factory :deleted_sticker, parent: :sticker do
    deleted_at DateTime.now
  end
end