#encoding: utf-8
class Report < ActiveRecord::Base
  attr_accessible :anonymous, :category_id, :description, :lat, :lng, :category_fields, :image

  validates :category_id, presence: true

  belongs_to :category
  belongs_to :reportable, polymorphic: true
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

  scope :on_start_date, lambda {|from|
    where("created_at >= ?", from)
  }
      
  scope :on_finish_date, lambda { |to|
    where("created_at <= ?", to)
  }

  scope :with_status, lambda { |status|
    where(status: status) 
  }

  scope :on_category, lambda { |category| 
    where(category_id: category) 
  }

  acts_as_voteable

  def category_extra_fields
    self.category_fields.each do |k,v|
      errors.add k.to_sym, "must be present" if v.blank?
    end
  end

  def category?
    self.category.present? 
  end

  def self.filter_by_search(params)
    reports = Report.order('created_at')
    reports = reports.on_start_date(params[:start_date]) unless params[:start_date].blank?
    reports = reports.on_finish_date(params[:end_date]) unless params[:end_date].blank?
    reports = reports.with_status(params[:status]) unless params[:status].blank?
    reports = reports.on_category(params[:category_id]) unless params[:category_id].blank?
    reports
  end
end
