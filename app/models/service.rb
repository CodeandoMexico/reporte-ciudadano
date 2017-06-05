class Service < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :agency
  has_many :service_requests
  has_many :service_fields
  has_many :messages
  has_many :service_reports
  has_many :answers, class: SurveyAnswer, source: :survey_answers
  has_many :service_surveys_reports, class: ServiceSurveyReport, through: :service_surveys, source: :reports
  has_many :questions, through: :service_surveys
  belongs_to :service_admin, class: Admin, foreign_key: :service_admin_id
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :service_surveys, join_table: :services_service_surveys

  accepts_nested_attributes_for :service_fields, allow_destroy: true
  accepts_nested_attributes_for :messages, allow_destroy: true, reject_if: lambda { |attr| attr[:content].blank? }

  serialize :cis, Array

  #TODO: se debe de internacionalizar los textos.
  validates :name,
            :service_type,
            :organisation_id,
            :agency_id,
            :cis,
            :service_admin_id,
            presence: true

  validates_associated :service_fields

  scope :with_open_surveys, -> do
    joins(:service_surveys)
    .where('service_surveys.open = ?', true)
  end

  scope :active, -> { where(status: "activo") }

  before_save :refresh_dependency_attribute

  def refresh_dependency_attribute
    self[:dependency] = self.organisation.try(:name)
    self[:administrative_unit] = self.agency.try(:name)
  end

  # Override method in order to support legacy
  def dependency
    self.organisation.try(:name)
  end

  # Override method in order to support legacy
  def administrative_unit
    self.agency.try(:name)
  end

  def service_fields_names
    self.service_fields.pluck(:name).join(', ')
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

  def self.for_cis(cis_id)
    where("cis LIKE '%?%'", cis_id.to_i)
  end

  def answered_surveys
    answers.pluck(:user_id, :cis_id).uniq.count
  end

  def has_not_been_evaluated?
    answered_surveys.zero?
  end

  def cis_count
    cis.size
  end

  def cis_names
    Services.service_cis
            .select { |cis_hash| cis.include?(cis_hash[:id].to_s) }
            .map { |cis_hash| cis_hash[:name] }
            .join(", ")
  end

  def last_survey_reports
    service_surveys.map(&:last_report).reject(&:blank?).uniq
  end

  def last_survey_reports_for_cis(cis_id)
    service_surveys_reports.where(service_id: id, cis_id: cis_id).uniq
  end

  def last_report
    service_reports.order(created_at: :asc).last
  end

  def last_report_for_cis(cis_id)
    service_reports.with_cis_id(cis_id).last
  end

  def last_general_report
    service_reports.with_cis_id(nil).last
  end

  def service_requests_for_status(status_id)
    service_requests.select{ |request| request.status_id == status_id }.size
  end

  def service_requests_count
    service_requests.count
  end

  def evaluated_public_servants_count
    admins.count
  end
end
