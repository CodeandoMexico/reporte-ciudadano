class window.GeolocateMap

  constructor: (map_div_node, options) ->
    $(map_div_node).before("<p class='error-map alert alert-danger' style='display:none;'>Lo sentimos tu dirección esta fuera del alcance permitido</p>")
    @_add_listener_for_first_location()
    @_prepare_inputs(options['sync_input'])
    @map = new GeolocateMap.Map(map_div_node, options)
    @_add_listener_for_marker()
    @_add_listener_for_address_field()

  _prepare_inputs:(input_selectors) ->
    @jq_lat_field = $(input_selectors['latitude'])
    @jq_lng_field = $(input_selectors['longitude'])
    @jq_address_field = $(input_selectors['address'])

  _add_listener_for_marker: ->
    @map.marker.onDragEnd =>
      unless @map.validates_position(@map.marker.g_marker.getPosition())
        @map.marker.rollback_to_last_valid_position()
        @_display_map_error()

  _add_listener_for_address_field: ->
    @jq_address_field.on 'change', =>
      @map.validates_address_text @jq_address_field.val(), (result, is_valid) =>
        if is_valid
          @map.update_marker_position(result.geometry.location)
          @_update_lat_and_lng_from_marker()
        else
          @_rollback_to_last_valid_address()
          @_display_map_error()

    @jq_address_field.on 'focusin', =>
      @last_valid_address = @jq_address_field.val()

  _add_listener_for_first_location: ->
    $(window).on 'first_location', (e, data) =>
      if data.userPermission
        @_update_form_from_marker_values()
      else
        @_update_lat_and_lng_from_marker()


  _update_form_from_marker_values: ->
    @_update_lat_and_lng_from_marker()
    @_update_address_from_marker()

  _update_lat_and_lng_from_marker: ->
    @jq_lat_field.val(@map.marker.latitude())
    @jq_lng_field.val(@map.marker.longitude())

  _update_address_from_marker: ->
    @map.marker.humanize_current_position (address) =>
      @jq_address_field.val(address)

  _rollback_to_last_valid_address: ->
    @jq_address_field.val(@last_valid_address)

  _display_map_error: ->
    $('.error-map').fadeIn().delay(2000).fadeOut();









