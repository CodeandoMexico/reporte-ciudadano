# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    name { Faker::Lorem.word }

    factory :invalid_service do
      name nil
    end
  end
end
