class GeolocateMap.Marker

  constructor: (options) ->
    @g_marker = new google.maps.Marker(options)
    @_addDragStartListener()

  latitude: ->
    @g_marker.getPosition().lat()

  longitude: ->
    @g_marker.getPosition().lng()

  setPosition: (pos) ->
    @g_marker.setPosition(pos)

  getPosition: ->
    @g_marker.getPosition()

  rollback_to_last_valid_position: ->
    @g_marker.setPosition(@lastValidPosition)

  humanize_current_position: (cb) ->
    geocoder = new google.maps.Geocoder()
    geocoder.geocode {'latLng': @g_marker.getPosition()}, (results, status) =>
      if status == google.maps.GeocoderStatus.OK
        if results[0]
          cb(results[0].formatted_address)
        else
          cb('')
      else
        cb('')

  onDragEnd: (cb) ->
    google.maps.event.addListener @g_marker, 'dragend', =>
      cb()

  _addDragStartListener: ->
    google.maps.event.addListener @g_marker, 'dragstart', =>
      @lastValidPosition = @g_marker.getPosition()
