#encoding: utf-8
class Report < ActiveRecord::Base
  attr_accessible :anonymous, :category_id, :description, :lat, :lng, :category_fields, :image, :status_id, :address

  validates :category_id, presence: true

  belongs_to :category
  belongs_to :reportable, polymorphic: true
  has_many :comments

  validate :category_extra_fields

  serialize :category_fields, JSON

  attr_accessor :message

  mount_uploader :image, ImageUploader

  default_scope order: 'created_at DESC'
  belongs_to :status

  scope :on_start_date, lambda {|from|
    where("created_at >= ?", from)
  }
      
  scope :on_finish_date, lambda { |to|
    where("created_at <= ?", to)
  }

  scope :with_status, lambda { |status_id|
    where(status_id: status_id) 
  }

  scope :on_category, lambda { |category| 
    where(category_id: category) 
  }

  scope :find_by_ids, lambda { |ids|
    where("id IN (?)", ids.split(',')) 
  }

  scope :closed, lambda {
    where(status_id: 4)
  }

  scope :not_closed, lambda {
    where('status_id != ?', 4)
  }

  scope :open, lambda {
    where(status: 1)
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
    reports = reports.with_status(params[:status_id]) unless params[:status_id].blank?
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

  def date
    created_at.to_date 
  end

  ransacker :date do |parent|
    Arel::Nodes::InfixOperation.new('||',
                                    Arel::Nodes::InfixOperation.new('||', parent.table[:created_at], ' '), parent.table[:created_at])
  end

  def self.chart_data
    statuses = Status.all
    query = statuses.map { |status| "count(case when status_id = '#{status.id}' then 1 end) as status_#{status.id}" }.join(",") 
    Report.unscoped.select("category_id, #{query}").group(:category_id).order('category_id')
  end
end
