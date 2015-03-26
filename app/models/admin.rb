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
  has_one :api_key
  mount_uploader :avatar, AvatarUploader

  def to_s
    self.email 
  end

  def api_key?
    self.api_key.present? 
  end

end
