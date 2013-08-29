jQuery ->

  if $('#reports-chart').length > 0
    chart_data = $('#reports-chart').data('chart-data')
    status_names = $('#reports-chart').data('status-names')
    series = []
    index = 1

    for status_name in status_names
      series.push({
        name: status_name
        data: $.map chart_data, (e, i) -> parseInt(e["status_#{index}"])
      })
      index++

    $('#reports-chart').highcharts({
      chart:
        type: 'bar'
      title:
        text: 'Reportes por categoría'
      xAxis:
        categories: $('#reports-chart').data('category-names')
      yAxis:
        allowDecimals: false
        gridLineWidth: 0
        max: $('#reports-stats').data('total')
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
