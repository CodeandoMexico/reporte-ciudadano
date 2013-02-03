module Services 
  class Omniauth 

    def initialize(omniauth = nil)
      @omniauth = omniauth
      @provider = omniauth['provider']
      @uid = omniauth['uid']
    end

    def authenticated?
      user.present?
    end

    def user
      user_from_authentication.try(:user) || user_created 
    end

    def user_from_authentication
      Authentication.find_by_provider_and_uid(@provider, @uid)
    end

    def user_created
      User.create_with_omniauth(@omniauth)            
    end

  end
end

