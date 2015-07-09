FactoryGirl.define do
  factory :sticker do
    description 'Default description'
    association :owner, factory: :user
    association :performer, factory: :user
  end

  factory :invalid_sticker, parent: :sticker do
    description nil
  end
end