class window.MapBounder

  constructor: (html_node, @jq_save_button) ->
    constraints =  $(html_node).data('map-constraints')
    @map = @_init_map(html_node, constraints)
    @_make_map_fit_bounds(constraints.bounds)
    @_add_listener_for_update()

  _init_map: (html_node, constraints) ->
    map_options =
      zoom: parseInt(constraints.zoom)
      center: new google.maps.LatLng(0.0, 0.0)
    new google.maps.Map(html_node, map_options)

  _make_map_fit_bounds: (bounds) ->
    sw = new google.maps.LatLng(bounds[0][0], bounds[0][1])
    ne = new google.maps.LatLng(bounds[1][0], bounds[1][1])
    @map.fitBounds(new google.maps.LatLngBounds(sw, ne))

  _add_listener_for_update: ->
    map = @map
    @jq_save_button.on 'click',  ->
      data = "{\"zoom\": #{map.getZoom()}, \"bounds\": #{map.getBounds().toString()}}"
      data = data.replace(/\(/g,"[").replace(/\)/g,"]");
      $.ajax
        type: "PUT"
        url: $(@).data('url')
        data:
          setting:
            map_constraints: data
        success: (data, status, xhr) =>
          setTimeout (=>
            $(@).next('.js-save-box').addClass('hide')
          ), 500
        error: (xhr, status, error) ->
          console.log 'error'
