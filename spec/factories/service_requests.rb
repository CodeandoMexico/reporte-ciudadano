# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_request do
    category
    status
    association :requester, factory: :user
    address     { Faker::Lorem.words(3) }
    description { Faker::Lorem.paragraph(2) }

    factory :invalid_service_request do
      category_id nil
    end
  end
end
