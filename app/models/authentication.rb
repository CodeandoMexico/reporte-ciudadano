class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid

  belongs_to :user

  def self.create_with_omniauth(omniauth)
    Authentication.new(provider: omniauth['provider'], uid: omniauth['uid']).save
  end
end
