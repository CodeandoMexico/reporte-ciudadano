# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :api_key do
    access_token { SecureRandom.hex }
    admin factory: :admin

    factory :invalid_api_key do
      access_token nil
      admin nil
    end
  end
end
