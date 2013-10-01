# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    user
    uid '12345678'
    provider 'facebook'
  end
end
