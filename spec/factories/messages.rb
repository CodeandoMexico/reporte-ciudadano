# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    content { Faker::Lorem.paragraph(5) }
    service
    status
  end
end
