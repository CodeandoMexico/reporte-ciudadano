class window.PinDropper

  constructor: (map_selector, markers, options) ->
    @map = new google.maps.Map($(map_selector)[0], @_options(options))
    @markers = @_build_markers_on_bulk(markers)

  updateMarkers: (markers) ->
    @clearMap()
    @markers = @_build_markers_on_bulk(markers)

  clearMap: ->
    for marker in @markers
      marker.setMap(null)
    @markers = []

  _options: (raw_options) ->
    mapOptions = $.extend({
      scrollwheel: false
      zoom: 15
      center: new google.maps.LatLng(0.0,0.0)
      zoomControlOptions:
        position: google.maps.ControlPosition.RIGHT_CENTER
      mapTypeId: google.maps.MapTypeId.ROADMAP
      scaleControl: true
      html5: false
    }, raw_options)

  _build_markers_on_bulk: (markers) ->
    map = @map
    bounds = new google.maps.LatLngBounds()
    info_window_content = "<strong></strong>"
    info_window = new google.maps.InfoWindow(
      content: info_window_content
      maxWidth: 400
    )

    markers = $(markers).map (i, e) ->
      pos = new google.maps.LatLng(e.lat, e.lng)
      bounds.extend(pos)

      marker = new google.maps.Marker(
        position: pos
        map: map
        draggable: false
        animation: google.maps.Animation.DROP
      )

      google.maps.event.addListener marker, 'click', ->
        info_window.setContent e.description
        info_window.open(map, marker)

      marker

    if markers.length > 1
      @map.fitBounds(bounds)
    else if markers.length == 1
      @map.setCenter(markers[0].getPosition())

    markers
