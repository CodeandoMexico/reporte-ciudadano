$questions = {}

$(document).on 'ready page:load', ->
  $.each $('.js-answer-selection'), ->
    answerType = $(this).val()
    if answerType == 'binary' || answerType == 'rating'
      $(this).parent().closest(".js-question").find(".js-question-value").removeClass('hidden')
    $(this).parent().closest(".js-question").find(".js-" + answerType).removeClass("hidden")

$(document).on 'change', '.js-answer-selection', ->
  answerType = $(this).val()
  showAnswerType(this, answerType)

$(document).on 'change', '.js-criterion-selection', ->
  url = $(this).data('questions-text-url')

  if $.isEmptyObject($questions)
    getQuestionsCollection(url, this)
  else
    showQuestionsList(this)

$(document).on 'click', '.js-question-item', ->
  questionText = $(this).text()
  answerType = $(this).data("answer")
  element = $(this).parent().closest(".js-question").find(".js-question-text")

  $(element).val(questionText)
  $(element).parent().closest(".js-question").find(".js-answer-selection option[value='" + answerType + "']").attr('selected', 'selected')
  showAnswerType(this, answerType)

showAnswerType = (element, answerType) ->
  if answerType == 'binary' || answerType == 'rating'
    $(element).parent().closest(".js-question").find(".js-question-value").removeClass('hidden')
  $(element).parent().closest(".js-question").find(".js-answer-wrapper").addClass("hidden")
  $(element).parent().closest(".js-question").find(".js-" + answerType).removeClass("hidden")

showQuestionsList = (element) ->
  criterion = $(element).val()
  criterionLabel = $("option:selected", element).text()
  list = $(element).parent().closest(".js-question").find(".js-answers-list")
  instructionsElement = $(element).parent().closest(".js-question").find(".js-question-text-instructions")

  if $questions[criterion].length > 0
    $(instructionsElement).html("<em>Puedes elegir una pregunta de <strong>" + criterionLabel + "</strong> de encuestas anteriores:</em>")
  else
    $(instructionsElement).html("<em>No hay preguntas anteriores para <strong>" + criterionLabel + "</strong>.</em>")

  $(list).html('')
  $.each $questions[criterion], (index, question) ->
    $(list).append("<li class='js-question-item' data-answer='" + question["answer_type"] + "'>" + question['text'] + "</li>")

getQuestionsCollection = (url, element) ->
  $.ajax
    url: url
    type: 'GET'
    dataType: "json"
    success: (data, textStatus, jqXHR) ->
      $questions = data["questions"]
      showQuestionsList(element)


