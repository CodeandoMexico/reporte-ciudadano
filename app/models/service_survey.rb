class ServiceSurvey < ActiveRecord::Base
  has_and_belongs_to_many :services, join_table: :services_service_surveys
  belongs_to :admin
  has_many :questions

  validates_presence_of :phase

  accepts_nested_attributes_for :questions

  def services_names
    services.map(&:name).join(", ")
  end

  def admin_name
    admin.name
  end
end