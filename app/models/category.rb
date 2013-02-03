class Category < ActiveRecord::Base
  attr_accessible :name, :category_fields_attributes
  has_many :reports

  validates :name, presence: true

  has_many :category_fields
  accepts_nested_attributes_for :category_fields, allow_destroy: true

  def category_fields_names
    self.category_fields.map(&:name).join(', ')
  end
end
