class Report < ActiveRecord::Base
  attr_accessible :anonymous, :category_id, :description, :lat, :lng, :category_fields

  validates :category_id, :lat, :lng, presence: true

  belongs_to :category

  validate :category_extra_fields

  serialize :category_fields, JSON

  def category_extra_fields
    self.category_fields.each do |k,v|
      errors.add k.to_sym, "must be present" if v.blank?
    end
  end

  def category?
    self.category.present? 
  end
end
