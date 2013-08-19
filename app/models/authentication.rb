class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid

  belongs_to :user

  def self.create_with_omniauth(omniauth)
    Authentication.new(provider: omniauth['provider'], uid: omniauth['uid']).save
  end

  def self.find_for_provider_oauth(omniauth, resource)
    case omniauth.provider
    when 'facebook' then find_or_create_with_facebook(omniauth, resource)
    when 'twitter' then find_or_cretae_with_twitter(omniauth, resource)
    end
  end

  def self.find_or_create_with_facebook(omniauth, resource)
    auth = Services::Omniauth.new(omniauth) 
    auth
  end

  def self.find_or_cretae_with_twitter(omniauth, resource)
    auth = Services::Omniauth.new(omniauth) 
    auth
  end
end
