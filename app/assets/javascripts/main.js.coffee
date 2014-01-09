$ ->

  # The body element has the controller and action name as class attribute
  current_controller_and_action = $("body").attr('class')

  $tabs = $('.menu a')
  # Activate the tab for the current controller and action
  $tabs.filter("[class='#{current_controller_and_action}']").addClass('active')
  # On click change active tab
  $tabs.click ->
    $tabs.removeClass 'active'
    $(@).addClass 'active'

  $('#service_request_status_id').change ->
    status_id = $(@).val()
    service_id = $(@).data('service-id')
    $.ajax(
      url: "/admins/services/#{service_id}/messages"
      data:
        status_id: status_id
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
    newReportMap = $('#new-report-map')
    mapConstraints = newReportMap.data('map-constraints')
    newReportMap.geolocateMap({
      html5: true
      zoom: mapConstraints.zoom
      sync_input:
        longitude: '#lng'
        latitude: '#lat'
        address: '#address'
      bounds:
        sw:
          latitude: mapConstraints.bounds[0][0]
          longitude: mapConstraints.bounds[0][1]
        ne:
          latitude: mapConstraints.bounds[1][0]
          longitude: mapConstraints.bounds[1][1]
    })

  if $("#reports-map").length > 0
    reports_markers = $(".recent-report-sum").map ->
      return { lat: $(this).data("lat"), lng: $(this).data("lng"), description: $(this).data("description") }

    $map = $(".map")
    lat = $map.attr("data-latitude")
    lng = $map.attr("data-longitude")

    $("#reports-map").pinDropper(reports_markers, {
      center: new google.maps.LatLng(lat, lng)
    })

  if $("#show-report-map").length > 0
    $("#show-report-map").geolocateMap({
      markers: [{
        lat: $("#show-report-map").data("latitude")
        lng: $("#show-report-map").data("longitude")
        description: $("#show-report-map").data("description")
      }]
      center: new google.maps.LatLng($("#show-report-map").data("latitude"), $("#show-report-map").data("longitude"))
    })
