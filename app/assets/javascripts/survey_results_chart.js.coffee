$(document).on 'ready page:load', ->
  $('.js-overall-chart').each ->
    positive = parseFloat($(this).data('positive'))
    negative = parseFloat($(this).data('negative'))
    title = $(this).data('title')

    if positive == 0 && negative == 0
      $(this).html("<b>Satisfacción general de servicios</b><p><em>No hay suficiente datos para crear el reporte.</em></p>")
    else
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
            innerSize: 25
            depth: 100
            dataLabels:
              distance: 5
        point:
          showInLegend: true
        tooltip:
          pointFormat: '<b>{point.y}%</b>'
        series:
          [
            name: title,
            data: [[ "Percepción positiva", positive], ["Percepción negativa", negative]]
          ]