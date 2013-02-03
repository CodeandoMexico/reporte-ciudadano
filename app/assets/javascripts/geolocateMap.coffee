(($) ->

  helpers = {
    set_marker_position: (marker, lat, lng) =>
      pos = new google.maps.LatLng(lat, lng)
      marker.setPosition(pos)
      map = marker.getMap()
      map.setCenter(pos)
                
    marker_lat: (marker) ->
      marker.getPosition().lat()

    marker_lng: (marker) ->
      marker.getPosition().lng()

    set_form_input_value_from_marker: ($lat, $lng, $address, marker) ->
      $lat.val(helpers.marker_lat(marker))
      $lng.val(helpers.marker_lng(marker))
      helpers.set_address_to_input_from_marker($address, marker)

    set_address_to_input_from_marker: ($input, marker) ->
      geocoder = new google.maps.Geocoder()
      latLng = marker.getPosition()
      geocoder.geocode {'latLng': latLng}, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          if results[0]
            $input.val(results[0].formatted_address)
          else
            console.log("geocoder not found")
            $input.val("")
        else
          console.log("geocoder fail: #{status}")
          $input.val("")

    set_marker_and_map_from_input_address: (marker, map, $input) ->
      geocoder = new google.maps.Geocoder()
      geocoder.geocode {address: $input.val()}, (result, status) ->
        position = result[0].geometry.location
        map.setCenter(position)
        map.setZoom(15)
        marker.setPosition(position)
  }

  methods =
    init: (options) ->
      options ?= {}

      center = null

      if options.latitude and options.longitude
        options['center'] = new google.maps.LatLng(options.latitude, options.longitude)

      mapOptions = $.extend({
        zoom: 15
        center: new google.maps.LatLng(0.0, 0.0)
        mapTypeId: google.maps.MapTypeId.ROADMAP
        scaleControl: true
        html5: true
      }, options)

      @map = new google.maps.Map(this[0], mapOptions)

      @marker = new google.maps.Marker({
          'position': mapOptions['center']
          'map': @map
          'draggable': true
      })

      if mapOptions['html5'] and navigator.geolocation
        navigator.geolocation.getCurrentPosition(
          ((position) =>
            helpers.set_marker_position(@marker, position.coords.latitude, position.coords.longitude)
            helpers.set_form_input_value_from_marker($lat, $lng, $address, @marker)
          ),
          ((msg) ->
            console.log("geolocation error: #{msg}")
          )
        )

      sync_elements = mapOptions['sync_input']

      # input listeners
      if $lat = $(sync_elements['latitude'])
        $lat.val(helpers.marker_lat(@marker))
        $lat.on 'change', =>
          helpers.set_marker_position(@marker, $(this).val(), helpers.marker_lng(@marker))

      if $lng = $(sync_elements['longitude'])
        $lng.val(helpers.marker_lng(@marker))
        $lng.on 'change', =>
          helpers.set_marker_position(@marker, helpers.marker_lat(@marker), $(this).val())

      if $address = $(sync_elements['address'])
        helpers.set_address_to_input_from_marker($address, @marker)

        $address.on 'change', =>
          helpers.set_marker_and_map_from_input_address(@marker, @map, $address)

      # on marker move
      google.maps.event.addListener @marker, 'dragend', =>
        marker = @marker
        map = @map
        position = marker.getPosition()

        if sync_elements['latitude']
          $lat.val(position.lat())


        if sync_elements['longitude']
          $lng = $(sync_elements['longitude'])
          $lng.val(position.lng())

        if sync_elements['address']
          $address = $(sync_elements['address'])
          helpers.set_address_to_input_from_marker($address, @marker)

      return this


  # trigger methods for plugin
  $.fn.geolocateMap = (method) ->
    if methods[method]
      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ))
    else if typeof method == 'object' || ! method
      return methods.init.apply( this, arguments )
    else
      $.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' )
      
)(jQuery)
