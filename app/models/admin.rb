class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  #before_save :ensure_authentication_token

  # attr_accessible :title, :body

  has_many :comments, as: :commentable
  has_many :service_requests, as: :requester
  has_many :managed_services, class: Service
  has_one :api_key
  belongs_to :service
  mount_uploader :avatar, AvatarUploader

  def to_s
    self.email
  end

  def api_key?
    self.api_key.present?
  end

  def self.service_admins_sorted_by_name
    where(is_service_admin: true).order(name: :asc)
  end

  def self.public_servants_by_dependency(dependency)
    where(is_public_servant: true, disabled: false, dependency: dependency).order(name: :asc)
  end

  def services_ids
    managed_services.map(&:id)
  end

  def self.service_admins
    where(is_service_admin: true)
  end

  def is_service_admin?
    is_service_admin
  end

  def is_super_admin?
    !(is_service_admin || is_public_servant)
  end

  def has_service_assigned?
    service.present?
  end

  def assigned_service_name
    service.name
  end
end
