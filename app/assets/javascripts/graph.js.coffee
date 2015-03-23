$(document).on 'ready page:load', ->
  $('#reports-chart').each ->
    chart_data = $('#reports-chart').data('chart-data')
    status_data = $('#reports-chart').data('status-data')
    series = []
    services_names = []

    for status in status_data
      series.push({
        name: status["name"]
        data: $.map chart_data, (e, i) -> parseInt(e["status_#{status['id']}"])
      })

    for service in chart_data
      services_names.push(service.name)

    $('#reports-chart').highcharts({
      chart:
        type: 'bar'
      title:
        text: ''
      xAxis:
        categories: services_names
      yAxis:
        allowDecimals: false
        gridLineWidth: 0
        max: $('.reports-stats').data('total')
        min: 0
        title: 'Total de reportes'
      legend:
        backgroundColor: '#FFFFFF',
        reversed: true
      plotOptions:
        series:
          stacking: 'normal'
      series: series
    })
