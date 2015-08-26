# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_request do
    service
    status
    cis [1]
    service_admin_id FactoryGirl.build(:admin,id: 1)
    public_servant_id FactoryGirl.build(:admin, :service_admin, id: 1, is_public_servant: 1)
    byebug
    association :requester, factory: :user
    address     { FFaker::Lorem.words(3) }
    description { FFaker::Lorem.paragraph(2) }
  end
end
