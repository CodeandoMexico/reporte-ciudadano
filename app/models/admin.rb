class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  before_create :generate_authentication_token

  has_many :comments, as: :commentable
  has_many :service_requests, as: :requester
  has_many :managed_services, class: Service, foreign_key: :service_admin_id
  has_many :assigned_services, class: Service, foreign_key: :public_servant_id
  has_one :api_key
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

  def self.disabled_public_servants_by_dependency(dependency)
    where(is_public_servant: true, disabled: true, dependency: dependency).order(name: :asc)
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

  def assigned_service_name
    service.name
  end

  def active_for_authentication?
    super && (self.is_super_admin? || self.is_service_admin? || (self.is_public_servant && !self.disabled))
  end

  def inactive_message
    I18n.t("flash.public_servant.disabled_admin")
  end

  def is_active?
    active
  end

  private

  def generate_authentication_token
    token_generator = UniqueTokenGenerator.new(Admin, :authentication_token)
    self.authentication_token = token_generator.generate_token
  end
end
