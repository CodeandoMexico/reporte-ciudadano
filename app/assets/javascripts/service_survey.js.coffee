$ ->
  # Este evento se usa en vista de admin
  # de service_surveys
  $(".js-generate-report").click  ->
   submit_object = $(this).data('submit')
   $(submit_object).submit()

