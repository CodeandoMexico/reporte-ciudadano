# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    association :voteable, factory: :report
    association :voter, factory: :user
  end
end
