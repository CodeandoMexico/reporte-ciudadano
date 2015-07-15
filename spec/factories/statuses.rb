# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    name { FFaker::Lorem.word }

    factory :invalid_status do
      name nil
    end

    factory :default_status do
      is_default true
    end
  end
end
