FactoryGirl.define do
  factory :sticker do
    description 'Default description'
    owner_id 1
  end

  factory :invalid_sticker, parent: :sticker do
    description nil
  end
end