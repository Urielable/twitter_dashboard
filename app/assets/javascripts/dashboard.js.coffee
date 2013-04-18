Chart = (->
  _new = (raw) ->
    colors = ['rgb(47, 55, 66)', 'rgb(209, 227, 5)', 'rgb(116, 204, 208)', 'rgb(254, 111, 95)', 'rgb(123, 126, 131)']
    input = JSON.parse raw
    categories = input.map (item) -> item[0]
    data = input.map (item, index) -> y: item[1], color: colors[index % colors.length]
    new Highcharts.Chart
      chart:
        renderTo: "mentions-chart"
        type: "column"
        backgroundColor: 'rgba(250, 250, 250, 0.1)'

      title:
        text: "Palabras más mencionadas en Twitter por usuarios localizados en Monterrey"
        style:
          fontWeight: 'bold'
      subtitle:
        text: "desde #{new Date()}"

      xAxis:
        categories: categories
      yAxis:
        title:
          text: "Menciones"

      plotOptions:
        column:
          cursor: "pointer"
          dataLabels:
            enabled: true
            color: 'rgb(47, 55, 66)'
            style:
              fontWeight: "bold"
            formatter: ->
              "#{@y}"

      tooltip:
        style:
          fontStyle: 'italic'
          fontFamily: 'Helvetica Neue'
        formatter: ->
          "<b>#{@point.category}</b> registra #{@y} menciones"

      series: [
        name: 'Menciones'
        data: data
        color: 'rgb(209, 227, 5)'
      ]

  new: _new
)()

$(document).on 'ready page:load', ->
  ws = new WebSocket 'ws://localhost:4567'
  ws.onmessage = (message) -> Chart.new message.data
