FactoryGirl.define do
  factory :dynamic_setting do
    ns "recommendations"
    name { Faker::Lorem.word }
    value 1
  end
end