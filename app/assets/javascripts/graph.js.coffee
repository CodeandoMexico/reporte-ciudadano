$(document).on 'ready page:load', ->
  $('#reports-chart').each ->
    chart_data = $('#reports-chart').data('chart-data')
    status_data = $('#reports-chart').data('status-data')
    series = []
    services_names = []
    index = 0
    color_ = null
    for status in status_data
      if(index == 0)
        color_ =  "#6fbbcf"; 
      if(index == 1) 
        color_ =  "#005195";
      if(index == 2)
        color_ =  "#f07b05";
      if(index == 3)
        color_ =  "#8cc63f";
      index+=1;
      series.push({
        name: status["name"]
        data: $.map chart_data, (e, i) -> parseInt(e["status_#{status['id']}"]
        )
        color: color_;
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
