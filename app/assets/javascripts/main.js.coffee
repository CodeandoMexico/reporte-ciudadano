$ ->

  $('#report_status').change ->
    status = $(@).val()
    report_id = $('#report_id').val()
    $.ajax(
      url: "/reports/#{report_id}/messages"
      data:
        state: status
      type: 'GET'
    )

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

    $map = $(".map")
    lat = $map.attr("data-latitude")
    lng = $map.attr("data-longitude")

    $("#reports-map").geolocateMap({
      markers: reports_markers
      center: new google.maps.LatLng(lat, lng)
    })

  if $("#show-report-map").length > 0
    $("#show-report-map").geolocateMap({
      markers: [{
        lat: $("#show-report-map").data("latitude")
        lng: $("#show-report-map").data("longitude")
      }]
    })
