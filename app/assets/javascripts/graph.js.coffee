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
    series:
      [
        {
          color: '#1fa69f',
          name: 'Cerrado',
          data: $.map chart_data, (e, i) -> parseInt(e.closed)
        },
        {
          color: '#59bee0',
          name: 'Revisión',
          data: $.map chart_data, (e, i) -> parseInt(e.revision)
        },
        {
          color: '#ceb340',
          name: 'Verificación',
          data: $.map chart_data, (e, i) -> parseInt(e.verification)
        },
        {
          color: '#888888',
          name: 'Abierto',
          data: $.map chart_data, (e, i) -> parseInt(e.opened)
        }
      ]
  })
