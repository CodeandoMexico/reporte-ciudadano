# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    name { Faker::Lorem.word }

    factory :invalid_status do
      name nil
    end
  end
end
