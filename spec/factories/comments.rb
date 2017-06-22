# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    content { FFaker::Lorem.paragraph(1) }
    service_request
    association :commentable, factory: :user

    factory :invalid_comment do
      content nil
    end
  end
end
