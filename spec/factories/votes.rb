# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    association :voteable, factory: :service_request
    association :voter, factory: :user
  end
end
