$(document).on 'ready page:load', ->
$ ->
    positive = Number($("#chartPerception").data('positive'))
    negative = Number($("#chartPerception").data('negative'))
    title = $("#chartPerception").data('title')
    subtitle = $("#chartPerception").data('subtitle')
    $("#chartPerception").highcharts
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