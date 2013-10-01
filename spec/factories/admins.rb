# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.free_email }
    password "iamthewalrus"
    password_confirmation "iamthewalrus"
    name { Faker::NameMX.full_name } 
    authentication_token { SecureRandom.hex(64) }

    factory :invalid_admin do
      email nil
      password nil
      password_confirmation nil
    end
  end
end
