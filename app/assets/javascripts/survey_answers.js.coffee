$questions = {}

$(document).on 'ready page:load', ->
  $.each $('.js-answer-selection'), ->
    answerType = $(this).val()
    $(this).parent().closest(".js-question").find(".js-" + answerType).removeClass("hidden")

$(document).on 'change', '.js-answer-selection', ->
  answerType = $(this).val()
  $(this).parent().closest(".js-question").find(".js-answer-wrapper").addClass("hidden")
  $(this).parent().closest(".js-question").find(".js-" + answerType).removeClass("hidden")

$(document).on 'change', '.js-criterion-selection', ->
  criterion = $(this).val()
  element = $(this).parent().closest(".js-question").find(".js-answers-list")
  $.ajax
    url: $(this).data('questions-text-url')
    type: 'GET'
    dataType: "json"
    data: { criterion: criterion }
    success: (data, textStatus, jqXHR) ->
      $questions = data["questions"]
      show_questions_list(criterion, element)

show_questions_list = (criterion, list) ->
  $(list).html('')
  $.each $questions[criterion], (index, text) ->
    $(list).append("<li>" + text + "</li>")
