# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_field do
    name { Faker::Lorem.words(2) }

  end
end
