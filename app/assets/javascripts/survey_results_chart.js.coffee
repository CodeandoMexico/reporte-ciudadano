$(document).on 'ready page:load', ->
  $.each $('.js-overall-chart'), ->
    positive = $(this).data('positive')
    negative = $(this).data('negative')
    title = $(this).data('title')

    $(this).highcharts
      chart:
        type: "pie"
        options3d:
          enabled: true
          alpha: 45
      title:
        text: title
      plotOptions:
        pie:
          innerSize: 100
          depth: 45
      series:
        [
          name: title
          data: [[ "Percepción positiva", positive], ["Percepción negativa", negative]]
        ]