class Service < ActiveRecord::Base
  has_many :service_requests

  validates :name, presence: true
  validates_associated :service_fields

  has_many :service_fields
  has_many :messages
  accepts_nested_attributes_for :service_fields, allow_destroy: true
  accepts_nested_attributes_for :messages, allow_destroy: true, reject_if: lambda { |attr| attr[:content].blank? }

  def service_fields_names
    self.service_fields.map(&:name).join(', ')
  end

  def self.chart_data
    count_query = Status.all.map do |status|
      "count(case when status_id = '#{status.id}' then 1 end) as status_#{status.id}"
    end.join(",")
    select_clause = "services.id, services.name"
    select_clause = "#{select_clause}, #{count_query}" unless count_query.blank?
    query = Service.joins('LEFT OUTER JOIN service_requests ON services.id = service_requests.service_id')
    query = query.select(select_clause)
    query = query.group('services.id')
    query = query.order('services.id')
  end

  def cant_be_deleted?
    service_requests.any?
  end
end
