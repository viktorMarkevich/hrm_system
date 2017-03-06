FactoryGirl.define do
  factory :geo_name do
    name "Kyiv"
    fclass "P"
    # association :geo_alternate_names, factory: :geo_alternate_name
  end
end