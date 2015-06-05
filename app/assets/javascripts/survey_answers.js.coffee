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
  url = $(this).data('questions-text-url')

  if $.isEmptyObject($questions)
    getQuestionsCollection(url, this)
  else
    showQuestionsList(this)

$(document).on 'click', '.js-question-item', ->
  questionText = $(this).text()
  element = $(this).parent().closest(".js-question").find(".js-question-text")
  $(element).val(questionText)

showQuestionsList = (element) ->
  criterion = $(element).val()
  criterion_label = $("option:selected", element).text()
  list = $(element).parent().closest(".js-question").find(".js-answers-list")
  instruction_element = $(element).parent().closest(".js-question").find(".js-question-text-instructions")

  if $questions[criterion].length > 0
    $(instruction_element).html("<em>Puedes elegir una pregunta de <strong>" + criterion_label + "</strong> de encuestas anteriores:</em>")
  else
    $(instruction_element).html("<em>No hay preguntas anteriores para <strong>" + criterion_label + "</strong>.</em>")

  $(list).html('')
  $.each $questions[criterion], (index, text) ->
    $(list).append("<li class='js-question-item'>" + text + "</li>")

getQuestionsCollection = (url, element) ->
  $.ajax
    url: url
    type: 'GET'
    dataType: "json"
    success: (data, textStatus, jqXHR) ->
      $questions = data["questions"]
      showQuestionsList(element)


