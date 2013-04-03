class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable
  
  before_save :reset_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :comments, as: :commentable
  has_many :reports, as: :reportable
  has_one :api_key

  def avatar_url
    Gravatar.new(self.email.to_s).image_url
  end

  def api_key?
    self.api_key.present? 
  end

end
