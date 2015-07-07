# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.free_email }
    password "iamthewalrus"
    password_confirmation "iamthewalrus"
    name { Faker::NameMX.full_name }
    username { Faker::Internet.user_name }

    factory :invalid_user do
      email nil
      password nil
      password_confirmation nil
    end

    trait :observer do
      is_observer true
    end
  end
end
