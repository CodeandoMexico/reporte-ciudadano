# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_field do
    name { FFaker::Lorem.word }
  end
end
