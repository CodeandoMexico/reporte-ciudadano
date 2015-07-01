$(document).on 'ready page:load', ->
  $("#chartPerception").each ->
    positive = Number($(this).data('positive'))
    negative = Number($(this).data('negative'))
    title = $(this).data('title')
    subtitle = $(this).data('subtitle')
    $(this).highcharts
      chart:
        type: "pie"
        options3d:
          enabled: true
          alpha: 45
      title:
        text: title
      subtitle:
        text: subtitle
      plotOptions:
        pie:
          innerSize: 100
          depth: 45
      series: [
        name: "Delivered amount"
        data: [[ "Percepción positiva", positive], [ "Percepcion negativa", negative]]
    ]