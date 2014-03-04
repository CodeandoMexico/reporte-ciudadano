class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid

  belongs_to :user

  def self.find_with_omniauth(omniauth)
    self.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
  end

end
