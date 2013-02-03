class User < ActiveRecord::Base
  attr_accessible :email, :name, :username

  has_many :authentications, dependent: :destroy
  has_many :reports
  has_many :comments, as: :commentable

  acts_as_voter

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

  def avatar_url
    if self.authentications.pluck(:provider).include? "twitter"
      twitter_auth = self.authentications.where(provider: 'twitter').first
      "http://api.twitter.com/1/users/profile_image?id=#{twitter_auth.uid}&size=bigger"
    elsif self.authentications.pluck(:provider).include? "facebook"
      facebook_auth = self.authentications.where(provider: 'facebook').first
      "https://graph.facebook.com/#{facebook_auth.uid}/picture"
    else
      Gravatar.new(self.email.to_s).image_url
    end
  end

end
