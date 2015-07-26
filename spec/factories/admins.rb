# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    email { FFaker::Internet.free_email }
    password "iamthewalrus"
    password_confirmation "iamthewalrus"
    name { FFaker::NameMX.full_name }
    authentication_token { SecureRandom.hex(64) }
    is_service_admin false
    is_public_servant false
    disabled false
    active true
    dependency "Dependency"

    factory :invalid_admin do
      email nil
      password nil
      password_confirmation nil
    end

    trait :service_admin do
      is_service_admin true
      active true
    end

    trait :public_servant do
      is_public_servant true
      active true
    end
  end
end
