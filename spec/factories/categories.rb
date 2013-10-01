# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.words(2) }

    factory :invalid_category do
      name nil
    end
  end
end
