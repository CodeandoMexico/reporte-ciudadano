$.fn.pinDropper = (markers, options) ->

  @each ->
    new PinDropper(this, markers, options)
