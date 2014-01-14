$.fn.geolocateMap = (options) ->

  @each ->
    new GeolocateMap(this, options)
