# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    content { FFaker::Lorem.word }
    service
    status
  end
end
