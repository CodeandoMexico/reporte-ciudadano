class User < ActiveRecord::Base
  attr_accessible :email, :name, :username

  has_many :authentications, dependent: :destroy
  has_many :reports, as: :reportable
  has_many :comments, as: :commentable

  acts_as_voter

  before_save :fetch_twitter_avatar, if: :has_twitter_auth?

  def self.create_with_omniauth(auth)
    user = User.new(name: auth["info"]["name"], username: auth["info"]["nickname"], email: auth["info"]["email"])
    authentication = user.authentications.build(provider: auth['provider'], uid: auth['uid']) 
    authentication.user = user
    user.save
    user 
  end

  def to_s
    self.name 
  end

  def avatar_url(version = nil)
    if self.authentications.pluck(:provider).include? "twitter"
      self.avatar
    elsif self.authentications.pluck(:provider).include? "facebook"
      facebook_auth = self.authentications.where(provider: 'facebook').first
      "https://graph.facebook.com/#{facebook_auth.uid}/picture"
    else
      Gravatar.new(self.email.to_s).image_url
    end
  end

  def fetch_twitter_avatar
    unless self.avatar?
      auth = self.authentications.select { |authentication| authentication.provider == "twitter" }.first
      image_url = Twitter.user(auth.uid.to_i).profile_image_url.sub("_normal", "")

      self.avatar = image_url
    end
  end

  private

    def has_twitter_auth?
      self.authentications.map(&:provider).include?("twitter")
    end

end
