class User < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :name

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable
  devise :omniauthable, :omniauth_providers => [:facebook, :twitter]

  has_many :authentications, dependent: :destroy
  has_many :service_requests, as: :requester
  has_many :comments, as: :commentable
  has_many :survey_answers

  acts_as_voter

  def self.find_or_build_with_omniauth(omniauth)
    user = User.find_by_email(omniauth[:info][:email]) unless omniauth[:info][:email].nil?
    if user.nil?
      user = User.new
      user.apply_omniauth(omniauth)
    else
      user.authentications.build(provider: omniauth[:provider], uid: omniauth[:uid])
    end
    user
  end

  def apply_omniauth(omniauth)
    self.collect_omniauth_attributes(omniauth)
    self.authentications.build(provider: omniauth[:provider], uid: omniauth[:uid])
  end

  def to_s
    self.name
  end

  def avatar_url
    if self.authentications.empty?
      Gravatar.new(self.email.to_s).image_url
    else
      self.avatar
    end
  end

  def collect_omniauth_attributes(omniauth)
    self.name = omniauth[:info][:name]
    self.username = omniauth[:info][:nickname]
    self.avatar = fetch_image_from_omniauth(omniauth)
    self.email = omniauth[:info][:email] if self.email.blank?
  end

  # Devise override
  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  # Devise override
  def password_required?
    super && (self.authentications.empty? || !self.password.blank?)
  end

  # Devise override
  def update_with_password(params, *options)
    if self.encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  private

    def fetch_image_from_omniauth(omniauth)
      case omniauth[:provider]
      when 'facebook' then "https://graph.facebook.com/#{omniauth.uid}/picture?type=large"
      when 'twitter' then omniauth[:info][:image]
      end
    end
end
