# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service do
    sequence(:name) { |n| "Service # #{n}" }
    status "activo"
    service_type "1"
    dependency "La dependencia"
    administrative_unit "unidad administrativa"
    cis [1]
    service_admin_id FactoryGirl.build(:admin,id: 1)
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
