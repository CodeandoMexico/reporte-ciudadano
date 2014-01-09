module ApplicationHelper

  def omniauth_provider_path(provider)
    "/auth/#{provider.to_s}"
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

  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end

  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-danger"
    end
  end

  def current_theme
    ApplicationSettings::CssTheme.get.name
  end

  def current_map_constrainsts
    ApplicationSettings::MapConstraints.get.map_constraints
  end

  def saving_spinner
    content_tag :span, 'Guardando...', class: 'hide js-save-box loading'
  end

  def errors_on_resource_for_field(resource, field)
    unless resource.errors[field].empty?
      content_tag :div, resource.errors[field].join(', ').to_s, class: 'errors-form'
    end
  end


end
