# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    sequence(:name) { |n| "Service # #{n}" }
    status "activo"

    factory :invalid_service do
      name nil
    end

    factory :service_with_service_fields do
      after(:create) do |service|
        service.service_fields << FactoryGirl.build(:service_field)
      end
    end
  end
end
