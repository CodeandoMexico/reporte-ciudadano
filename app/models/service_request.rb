#encoding: utf-8
class ServiceRequest < ActiveRecord::Base
  attr_accessible :anonymous, :service_id, :description, :lat, :lng,
                  :service_fields, :media, :status_id, :address, :title

  attr_accessor :message

  validates :service_id, presence: true
  validates :description, presence: true
  validate :service_extra_fields

  before_validation :assign_default_status, on: :create

  belongs_to :service
  belongs_to :requester, polymorphic: true
  belongs_to :status
  has_many :comments

  serialize :service_fields, JSON

  mount_uploader :media, ImageUploader
  acts_as_voteable

  default_scope order: 'created_at DESC'

  scope :on_start_date, lambda {|from|
    where("service_requests.created_at >= ?", from) unless from.blank?
  }

  scope :on_finish_date, lambda { |to|
    where("service_requests.created_at <= ?", to) unless to.blank?
  }

  scope :with_status, lambda { |status_id|
    where(status_id: status_id) unless status_id.blank?
  }

  scope :on_status_name, lambda { |status_name|
    joins(:status).where('statuses.name = ?', status_name) unless status_name.blank?
  }

  scope :on_service, lambda { |service_ids|
    where(service_id: service_ids.split(',')) unless service_ids.blank?
  }

  scope :find_by_ids, lambda { |ids|
    where("service_requests.id IN (?)", ids.split(',')) unless ids.blank?
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

  def service?
    self.service.present?
  end

  def self.filter_by_search(params)
    requests = ServiceRequest.order('created_at DESC')
    requests = requests.on_start_date(params[:start_date])
    requests = requests.on_finish_date(params[:end_date])
    requests = requests.with_status(params[:status_id])
    requests = requests.on_service(params[:service_id])
    requests = requests.find_by_ids(params[:service_request_ids])
    requests
  end

  def self.filter_by_search_311(params)
    requests = ServiceRequest.order('created_at DESC')
    if params[:service_request_id].present?
      requests = requests.find_by_ids(params[:service_request_id])
    else
      requests = requests.on_start_date(params[:start_date])
      requests = requests.on_finish_date(params[:end_date])
      requests = requests.on_service(params[:service_code])
      requests = requests.on_status_name(params[:status])
    end
    requests
  end

  def service_requester
    if self.anonymous?
      { avatar_url: 'http://www.gravatar.com/avatar/foo', name: 'Anónimo' }
    else
      { avatar_url: self.requester.avatar_url, name: self.requester.name }
    end
  end

  def date
    created_at.to_date 
  end

  ransacker :date do |parent|
    Arel::Nodes::InfixOperation.new('||',
                                    Arel::Nodes::InfixOperation.new('||', parent.table[:created_at], ' '), parent.table[:created_at])
  end

  private

  def service_extra_fields
    self.service_fields.each do |k,v|
      errors.add(k.to_sym, I18n.t('errors.messages.blank')) if v.blank?
    end
  end

  def assign_default_status
    self.status = Status.where(is_default: true).first
  end

end
