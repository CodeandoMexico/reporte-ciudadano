class Category < ActiveRecord::Base
  attr_accessible :name, :category_fields_attributes, :messages_attributes, :status
  has_many :reports

  validates :name, presence: true

  has_many :category_fields
  has_many :messages
  accepts_nested_attributes_for :category_fields, allow_destroy: true
  accepts_nested_attributes_for :messages, allow_destroy: true, reject_if: lambda { |attr| attr[:content].blank? }

  def category_fields_names
    self.category_fields.map(&:name).join(', ')
  end
end
