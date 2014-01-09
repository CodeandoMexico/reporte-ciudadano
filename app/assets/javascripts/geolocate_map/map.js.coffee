class GeolocateMap.Map

  constructor: (html_node, options) ->
    @_options = options
    @g_map = new google.maps.Map(html_node, @_parse_options_for_map())
    @bounds = @_build_bounds()
    @marker = @_build_marker_on_center()
    @_update_marker_to_current_position()
    @_add_listener_for_map_drag_end()

  reset_to_center: ->
    center = @g_map.getCenter()
    x = center.lng()
    y = center.lat()
    maxX = @bounds.getNorthEast().lng()
    maxY = @bounds.getNorthEast().lat()
    minX = @bounds.getSouthWest().lng()
    minY = @bounds.getSouthWest().lat()

    x = minX if x < minX
    x = maxX if x > maxX
    y = minY if y > minY
    y = maxY if y < maxY

    @g_map.setCenter(new google.maps.LatLng(y, x))

  validates_position: (position) ->
    @bounds.contains(position)

  validates_address_text: (address, cb) ->
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {address: address, bounds: @bounds}, (result, status) =>
      if status == google.maps.GeocoderStatus.OK && @validates_position(result[0].geometry.location)
        cb(result[0], true)
      else
        cb(undefined, false)

  _add_listener_for_map_drag_end: ->
    google.maps.event.addListener @g_map, 'dragend', =>
      @reset_to_center unless @validates_position(@g_map.getCenter())

  _parse_options_for_map: ->
    mapOptions = $.extend({
      scrollwheel: false
      center: new google.maps.LatLng(0.0,0.0)
      zoomControlOptions:
        position: google.maps.ControlPosition.RIGHT_CENTER
      mapTypeId: google.maps.MapTypeId.ROADMAP
      scaleControl: true
      html5: false
    }, @_options)

  _build_marker_on_center: ->
    new GeolocateMap.Marker(
      position: @g_map.getCenter()
      map: @g_map
      draggable: true
    )

  _update_marker_to_current_position: ->
    if @_options['html5'] and navigator.geolocation
      navigator.geolocation.getCurrentPosition(
        ((position) =>
          latLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
          if @validates_position(latLng)
            @marker.setPosition(latLng)
            @g_map.setCenter(latLng)
          $(window).trigger('first_location')
        ),
        ((msg) ->
          console.log("geolocation error: #{msg}")
        )
      )

  _build_bounds: ->
    bounds = @_options['bounds']
    g_bounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(bounds.sw.latitude, bounds.sw.longitude)
      new google.maps.LatLng(bounds.ne.latitude, bounds.ne.longitude)
    )
    @g_map.setCenter(g_bounds.getCenter())
    @g_map.fitBounds(g_bounds)
    g_bounds
