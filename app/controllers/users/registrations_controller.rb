class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def new
    session[:omniauth] = nil # delete omniauth saved state
    super
  end

  def create
    super do |user|
      UserMailer.welcome(user).deliver_now
      session[:omniauth] = nil unless resource.new_record?
    end
  end


  def finish_registration
    self.resource = resource_class.new
    self.resource.apply_omniauth(omniauth_hash)
    respond_with self.resource
  end

  private

  def build_resource(hash=nil)
    super
    if session[:omniauth]
      self.resource.apply_omniauth(omniauth_hash)
      self.resource.valid?
    end
  end

  def omniauth_hash
    session[:omniauth].deep_symbolize_keys
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :email, :telephone_number, :password)
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :telephone_number, :password, :password_confirmation, :current_password) }
  end
end
