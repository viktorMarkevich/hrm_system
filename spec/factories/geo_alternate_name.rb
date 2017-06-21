FactoryGirl.define do

  factory :geo_alternate_name do
    name 'Киев'
    association :geo_name, factory: :geo_name
  end

end