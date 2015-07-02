FactoryGirl.define do
  factory :sticker do
    description 'Default description'
  end

  factory :invalid_sticker, parent: :sticker do
    description nil
  end
end