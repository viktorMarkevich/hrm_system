include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :image do
    avatar_file_name { fixture_file_upload(Rails.root.join('app/assets/image/missing_medium.png'), 'image/png') }
  end

end