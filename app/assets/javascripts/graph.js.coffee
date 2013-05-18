jQuery ->

  chart_data = $('#reports-chart').data('chart-data')

  $('#reports-chart').highcharts({
    chart:
      type: 'bar'
    title:
      text: 'Reportes por categoría'
    xAxis:
      categories: $('#reports-chart').data('category-names')
    yAxis:
      min: 0
      title: 'Total de reportes'
    legend:
      backgroundColor: '#FFFFFF',
      reversed: true
    plotOptions:
      series:
        stacking: 'normal'
    series:
      [
        {
          name: 'Cerrado',
          data: $.map chart_data, (e, i) -> parseInt(e.closed)
        },
        {
          name: 'Revisión',
          data: $.map chart_data, (e, i) -> parseInt(e.revision)
        },
        {
          name: 'Verificación',
          data: $.map chart_data, (e, i) -> parseInt(e.verification)
        },
        {
          name: 'Abierto',
          data: $.map chart_data, (e, i) -> parseInt(e.opened)
        }
      ]
  })
