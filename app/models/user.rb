class User < ActiveRecord::Base
  attr_accessible :email, :name, :username

  validates :email, :name, presence: true

  has_many :authentications, dependent: :destroy

  def self.create_with_omniauth(auth)
    user = User.new(name: auth["info"]["name"], username: auth["info"]["nickname"], email: auth["info"]["email"])
    authentication = user.authentications.build(provider: auth['provider'], uid: auth['uid']) 
    authentication.user = user
    user.save
    user 
  end
end
