# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_request do
    service
    status
    association :requester, factory: :user
    address     { Faker::Lorem.words(3) }
    description { Faker::Lorem.paragraph(2) }
  end
end
