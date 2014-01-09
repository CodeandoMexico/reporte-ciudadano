$.fn.mapBounder = (save_button) ->
  @each ->
    new MapBounder(this, save_button)
