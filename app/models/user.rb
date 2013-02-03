class User < ActiveRecord::Base
  attr_accessible :email, :name, :username

  has_many :authentications, dependent: :destroy
  has_many :reports
  has_many :comments, as: :commentable

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
end
