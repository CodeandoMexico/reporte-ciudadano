# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    category
    association :reportable, factory: :user
    address     { Faker::Lorem.words(3) }
    description { Faker::Lorem.paragraph(2) }

    factory :invalid_report do
      category_id nil
    end
  end
end
