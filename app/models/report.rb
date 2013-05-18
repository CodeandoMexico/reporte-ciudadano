#encoding: utf-8
class Report < ActiveRecord::Base
  attr_accessible :anonymous, :category_id, :description, :lat, :lng, :category_fields, :image, :status

  validates :category_id, presence: true

  belongs_to :category
  belongs_to :reportable, polymorphic: true
  has_many :comments

  validate :category_extra_fields

  serialize :category_fields, JSON

  attr_accessor :message

  mount_uploader :image, ImageUploader

  default_scope order: 'created_at DESC'

  STATUS_LIST = {
    :open => "Abierto",
    :verification => "Verificación",
    :revision => "Revisión",
    :closed => "Cerrado"
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

  scope :find_by_ids, lambda { |ids|
    where("id IN (?)", ids.split(',')) 
  }

  scope :closed, lambda {
    where(status: :closed)
  }

  scope :not_closed, lambda {
    where('status != ?', :closed)
  }

  scope :open, lambda {
    where(status: :open)
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
    reports = reports.find_by_ids(params[:report_ids]) unless params[:report_ids].blank?
    reports
  end

  def reporter
    if self.anonymous?
      { avatar_url: 'http://www.gravatar.com/avatar/foo', name: 'Anónimo' }
    else
      { avatar_url: self.reportable.avatar_url, name: self.reportable.name }
    end
  end

end
