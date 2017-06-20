FactoryGirl.define do

  factory :tag, class: ActsAsTaggableOn::Tag do |f|
    f.sequence(:name) { |n| "tag_#{n}" }
  end

end