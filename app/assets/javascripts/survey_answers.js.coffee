$(document).on 'ready page:load', ->
  $(".js-answer-selection").on 'change', ->
    answerType = $(this).val()
    $(".js-answer-wrapper").addClass("hidden")
    $("#" + answerType).removeClass("hidden")