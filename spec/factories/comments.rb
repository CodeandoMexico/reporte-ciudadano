# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.paragraph(5) }
    service_request
    association :commentable, factory: :user

    factory :invalid_comment do
      content nil
    end
  end
end
