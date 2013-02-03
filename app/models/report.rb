#encoding: utf-8
class Report < ActiveRecord::Base
  attr_accessible :anonymous, :category_id, :description, :lat, :lng, :category_fields, :image

  validates :category_id, presence: true

  belongs_to :category
  belongs_to :user
  has_many :comments

  validate :category_extra_fields

  serialize :category_fields, JSON

  mount_uploader :image, ImageUploader

  default_scope order: 'created_at DESC'

  STATUS_LIST = {
    1 => "Abierto",
    2 => "Revisión",
    3 => "Cerrado"
  }

  def category_extra_fields
    self.category_fields.each do |k,v|
      errors.add k.to_sym, "must be present" if v.blank?
    end
  end

  def category?
    self.category.present? 
  end
end
