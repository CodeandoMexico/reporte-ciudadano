class Service < ActiveRecord::Base
  has_many :service_requests

  validates :name, presence: true
  validates_associated :service_fields

  has_many :service_fields
  has_many :messages
  belongs_to :service_admin, class: Admin, foreign_key: :service_admin_id
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :service_surveys, join_table: :services_service_surveys

  accepts_nested_attributes_for :service_fields, allow_destroy: true
  accepts_nested_attributes_for :messages, allow_destroy: true, reject_if: lambda { |attr| attr[:content].blank? }

  serialize :cis, Array

  def service_fields_names
    self.service_fields.map(&:name).join(', ')
  end

  def self.chart_data(service_admin_id: nil)
    count_query = Status.all.map do |status|
      "count(case when status_id = '#{status.id}' then 1 end) as status_#{status.id}"
    end.join(",")
    select_clause = "services.id, services.name"
    select_clause = "#{select_clause}, #{count_query}" unless count_query.blank?
    query = Service
    query = query.where(service_admin_id: service_admin_id) if service_admin_id.present?
    query = query.joins('LEFT OUTER JOIN service_requests ON services.id = service_requests.service_id')
    query = query.select(select_clause)
    query = query.group('services.id')
    query = query.order('services.id')
  end

  def cant_be_deleted?
    service_requests.any?
  end

  def self.unmanaged
    where(service_admin_id: nil)
  end

  def self.for_service_admin(admin)
    where("service_admin_id IS NULL OR service_admin_id = #{admin.id}")
  end

  def service_surveys_count
    service_surveys.count
  end

  def answered_surveys
    service_surveys.select { |survey| survey.answers.any? }.count
  end

  def cis_names
    Services
      .service_cis
      .select { |cis_hash| cis.include?(cis_hash[:id].to_s) }
      .map { |cis_hash| cis_hash[:name] }
      .join(", ")
  end

  def last_survey_reports
    service_surveys.map(&:last_report).reject(&:blank?)
  end
end
