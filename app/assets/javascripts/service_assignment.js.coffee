$(document).on 'ready page:load', ->
  $(".js-assign-service").on "click", ->
    $(this).addClass("hidden")
    $(".js-assign-service-form").removeClass("hidden")
