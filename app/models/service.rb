class Service < ActiveRecord::Base
  attr_accessible :name, :service_fields_attributes, :messages_attributes
  has_many :service_requests

  validates :name, presence: true

  has_many :service_fields
  has_many :messages
  accepts_nested_attributes_for :service_fields, allow_destroy: true
  accepts_nested_attributes_for :messages, allow_destroy: true, reject_if: lambda { |attr| attr[:content].blank? }

  def service_fields_names
    self.service_fields.map(&:name).join(', ')
  end
end
