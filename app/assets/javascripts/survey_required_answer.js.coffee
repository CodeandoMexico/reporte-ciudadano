$(document).on 'change', '.js-answer', ->
  button = $(".pt-page-current .js-button")
  button.removeAttr('disabled')
