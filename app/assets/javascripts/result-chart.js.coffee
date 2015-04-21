class @ResultChart
  constructor: (@questionGroupId, @colors, @fontFamily, @fontColor, @type)->
    @container = $("#js-json-results")

  onJSONResults: (data, status, xhr)=>
    $.each data, (index, resultObj)=>
      if $.isArray(resultObj.results)
        @appendNonAggregatableResults(resultObj)
      else
        @appendAggregatableResults(resultObj)

  appendNonAggregatableResults: (resultObj)->
    $resultsHtml = $ JST["templates/non_aggregatable"]
      resultObj: resultObj
      fFamily: @fontFamily
      fColor: @fontColor
    $resultsHtml.appendTo @container

  appendAggregatableResults: (resultObj)->
    colors = @colors

    # convert results to chart.js data format
    # fetch all values, and assign a color
    chartData = $.map _.values(resultObj.results), (value, index)->
      value: value, color: colors[index]
    legendData = $.map _.keys(resultObj.results), (key, index, value)->
      key: key, color: colors[index], value: chartData[index].value

    if @type == '1'
      $resultsHtml = $ JST["templates/aggregatable"]
        resultObj:  resultObj
        legendData: legendData
        fFamily: @fontFamily
        fColor: @fontColor
        bar: false
    else
      $resultsHtml = $ JST["templates/aggregatable"]
        resultObj:  resultObj
        legendData: legendData
        fFamily: @fontFamily
        fColor: @fontColor
        bar: true
    $resultsHtml.appendTo @container


    ctx = $resultsHtml.find("canvas").get(0).getContext("2d")
    if @type == '1'
      new Chart(ctx).Pie(chartData)
    else if @type == '2'
      labels = (item.key for item in legendData)
      values = (item.value for item in chartData)
      max = Math.max.apply(null, values)
      data = {
          labels,
          datasets: [
              {
                  fillColor: colors[0],
                  strokeColor: colors[1],
                  data: values
              }
          ]
      }
      new Chart(ctx).Bar(data, {scaleOverride: true, scaleStartValue: 0, scaleStepWidth: 1, scaleSteps: max+1, scaleFontFamily: @fontFamily})
    else if @type == '3'
      new Chart(ctx).Doughnut(chartData)

  render: ->
    jsonUrl = "/surveys/question_groups/#{@questionGroupId}/results"
    $.ajax jsonUrl, dataType: "json", success: @onJSONResults
