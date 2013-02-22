$ ->
  $(window).resize ->
    $("#main_width").html $(window).width()

  setTimeout ->
    hideFlashMessages()
  ,4000

  hideFlashMessages = ->
    $(".alert").fadeOut('slow')

  if $("#new-report-map").length > 0
    $("#new-report-map").geolocateMap({
      google_maps: {
        zoom: 15
      }
      markers: [
        {
          lat: $("#new-report-map").data("latitude")
          lng: $("#new-report-map").data("longitude")
          "sync_inputs": {
            lng: '#lng'
            lat: '#lat'
            address: '#address'
          }
        }
      ]
    })

  if $("#reports-map").length > 0
    reports_markers = $(".report").map ->
      return { lat: $(this).data("lat"), lng: $(this).data("lng"), draggable: false}

    $map = $(".map")
    lat = $map.attr("data-latitude")
    lng = $map.attr("data-longitude")

    $("#reports-map").geolocateMap({
      markers: reports_markers
      google_maps:
        zoom: 15
        center: new google.maps.LatLng(lat, lng)
    })

  if $("#show-report-map").length > 0
    $("#show-report-map").geolocateMap({
      markers: [{
        lat: $("#show-report-map").data("latitude")
        lng: $("#show-report-map").data("longitude")
        draggable: false
      }]
      google_maps:
        zoom: 15
    })
