$ ->
  $(window).resize ->
    $("#main_width").html $(window).width()

  $("#reports-map").geolocateMap({
    latitude: $("#reports-map").data("latitude")
    longitude: $("#reports-map").data("longitude")
    "sync_input": {
      longitude: '#lng'
      latitude: '#lat'
      address: '#address'
    }
  })
