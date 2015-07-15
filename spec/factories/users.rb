# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.free_email }
    password "iamthewalrus"
    password_confirmation "iamthewalrus"
    name { FFaker::NameMX.full_name }
    username { FFaker::Internet.user_name }

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
