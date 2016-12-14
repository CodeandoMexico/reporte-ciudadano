# Read about factories at https://github.com/thoughtbot/factory_girl
require 'ffaker'

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
  end

  factory :invalid_admin, parent: :admin do
    email nil
    password nil
    password_confirmation nil
  end

  factory :service_admin, parent: :admin do
    is_service_admin true
    active true
  end

  factory :observer, parent: :admin do
    is_observer true
  end

  factory :public_servant, parent: :admin do
    is_public_servant true
    active true
  end

end
