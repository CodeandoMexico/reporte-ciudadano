class ServiceSurvey < ActiveRecord::Base
  has_and_belongs_to_many :services, join_table: :services_service_surveys
  belongs_to :admin

  def services_names
    services.map(&:name).join(", ")
  end

  def admin_name
    admin.name
  end
end
