class ServiceRequestReading < ActiveRecord::Base
  belongs_to :service_request
  belongs_to :admin

  validates :admin_id,
            uniqueness: {
              scope: [:service_request]
            }
end
