module ApplicationHelper

  def omniauth_provider_path(provider)
    "auth/#{provider.to_s}"
  end

  def data_position
    if Rails.env.development?
      position = Geocoder.search("131.178.128.39").first
    else
      position = request.location
    end
    {"data-longitude" => position.longitude, "data-latitude" => position.latitude}
  end

end
