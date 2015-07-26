$ ->
  # Este evento se usa en vista de admin
  # de service_surveys
  $(".js-generate-report").click  ->
    submit_object = $(this).data('submit')
    $(submit_object).submit()
  $(".js-select-survey").change ->
    service_objects = ".js-service-" + $(this).data('serviceid')
    active_object = service_objects + ".js-survey-"+ $(this).val()
    $(service_objects).addClass("hidden")
    $(active_object).removeClass("hidden")