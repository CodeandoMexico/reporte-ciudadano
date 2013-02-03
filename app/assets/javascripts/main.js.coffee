$ ->
  $(window).resize ->
    $("#main_width").html $(window).width()

  if $("#new-report-map").length > 0
    $("#new-report-map").geolocateMap({
      html5: true
      latitude: $("#new-report-map").data("latitude")
      longitude: $("#new-report-map").data("longitude")
      "sync_input": {
        longitude: '#lng'
        latitude: '#lat'
        address: '#address'
      }
    })

  if $("#reports-map").length > 0
    reports_markers = $(".report").map ->
      return { lat: $(this).data("lat"), lng: $(this).data("lng") }

    $("#reports-map").geolocateMap({
      markers: reports_markers
    })
