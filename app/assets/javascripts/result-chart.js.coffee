class @ResultChart
  constructor: (@questionGroupId, @colors, @fontFamily, @fontColor)->
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
    legendData = $.map _.keys(resultObj.results), (key, index)->
      key: key, color: colors[index]

    $resultsHtml = $ JST["templates/aggregatable"]
      resultObj:  resultObj
      legendData: legendData
      fFamily: @fontFamily
      fColor: @fontColor
    $resultsHtml.appendTo @container

    ctx = $resultsHtml.find("canvas").get(0).getContext("2d")
    new Chart(ctx).Pie(chartData, {segmentStrokeColor : "#D5D5D5"})

  render: ->
    jsonUrl = "/surveys/question_groups/#{@questionGroupId}/results"
    $.ajax jsonUrl, dataType: "json", success: @onJSONResults
