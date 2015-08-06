$ ->
  # Este watcher se usa en vista de admin
  # de service_surveys

  $(".js-generate-report").click  ->
    submit_object = $(this).data('submit')
    $(submit_object).submit()
  # Este watcher se usa en /service_surveys
  showSurveyLink= (serviceid) ->
    service_objects = ".js-service-" + serviceid
    active_object = service_objects + ".js-cis-"+ $(".js-selector-service-"+serviceid+".js-select-cis").val()+ ".js-survey-"+ $(".js-selector-service-"+serviceid+".js-select-survey").val()
    $(service_objects).addClass("hidden")
    $(active_object).removeClass("hidden")

  $(".js-select-survey").change ->
    service_id = $(this).data('serviceid')
    if $(".js-select-survey.js-selector-service-"+service_id).val() > 0 && $(".js-select-cis.js-selector-service-"+service_id).val() > 0
      showSurveyLink(service_id)

  $(".js-select-cis").change ->
    service_id = $(this).data('serviceid')
    if $(".js-select-survey.js-selector-service-"+service_id).val() > 0 && $(".js-select-cis.js-selector-service-"+service_id).val() > 0
      showSurveyLink(service_id)
