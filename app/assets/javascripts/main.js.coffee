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

    $(".report").hover ->
      map = $("#reports-map").data("map")
      latLng = new google.maps.LatLng($(@).data("lat"), $(@).data("lng"))
      map.panTo(latLng)
      $(".map .details").hide();
      $(".map .details").fadeIn();

    $(window).resize ->


  if $("#show-report-map").length > 0
    $("#show-report-map").geolocateMap({
      markers: [{
        lat: $("#show-report-map").data("latitude")
        lng: $("#show-report-map").data("longitude")
      }]
    })

  

