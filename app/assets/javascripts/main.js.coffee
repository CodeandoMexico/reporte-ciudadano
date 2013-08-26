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

  $('#report_status').change ->
    status_id = $(@).val()
    report_id = $('#report_id').val()
    $.ajax(
      url: "/reports/#{report_id}/messages"
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
      return { lat: $(this).data("lat"), lng: $(this).data("lng"), description: $(this).data("description") }

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
        description: $("#show-report-map").data("description")
      }]
      center: new google.maps.LatLng($("#show-report-map").data("latitude"), $("#show-report-map").data("longitude"))
    })
