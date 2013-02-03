module ApplicationHelper

  def omniauth_provider_path(provider)
    "auth/#{provider.to_s}"
  end

end
