$(document).on 'ready page:load', ->
  $('#bounding-box-map').each ->
    $('#bounding-box-map').mapBounder($('.js-save-map'))
