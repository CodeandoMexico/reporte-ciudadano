$(document).on 'ready page:load', ->
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

  $("#new-report-map").each ->
    newReportMap = $('#new-report-map')
    mapConstraints = newReportMap.data('map-constraints')
    newReportMap.geolocateMap({
      html5: true
      zoom: parseInt(mapConstraints.zoom)
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

  $("#reports-map").each ->
    reports_markers = $(".recent-report-sum").map ->
      return { lat: $(this).data("lat"), lng: $(this).data("lng"), description: $(this).data("description") }

    $map = $(".map")
    lat = $map.attr("data-latitude")
    lng = $map.attr("data-longitude")

    report_map = new PinDropper('#reports-map', reports_markers, {center: new google.maps.LatLng(lat, lng)})

    $(".filters").on("ajax:success", (e, data, status, xhr) ->
      report_map.updateMarkers(
        $.map data['service_requests'], (val, index)->
          return { lat: val.lat, lng: val.long, description: val.description }
      )
      submit_button = $(this).find('.js-ajax-sender')
      submit_button.val(submit_button.data('stealth-label'))
    ).bind "ajax:error", (e, xhr, status, error) ->
      console.log 'ERROR!'

  $("#show-report-map").each ->
    $map = $("#show-report-map")
    lat = $map.attr("data-latitude")
    lng = $map.attr("data-longitude")

    reports_markers = [
      {
        lat: $map.data("latitude")
        lng: $map.data("longitude")
        description: $map.data("description")
      }
    ]

    $map.pinDropper(reports_markers, {
      center: new google.maps.LatLng(lat, lng)
    })

  $('.js-tabs a').on "click", (e)->
    e.preventDefault()
    $(this).tab('show')
