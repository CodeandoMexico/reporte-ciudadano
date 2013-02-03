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
    lng = position ? position.longitude : "17.065593"
    lat = position ? position.latitude : "-96.724253"
    { "data-longitude" => lng, "data-latitude" => lat }
  end

end
