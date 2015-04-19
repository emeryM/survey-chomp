class @ResultChart
  constructor: (@questionGroupId, @col)->
    @container = $("#js-json-results")

  onJSONResults: (data, status, xhr)=>
    $.each data, (index, resultObj)=>
      if $.isArray(resultObj.results)
        @appendNonAggregatableResults(resultObj)
      else
        @appendAggregatableResults(resultObj)

  appendNonAggregatableResults: (resultObj)->
    $resultsHtml = $ JST["templates/non_aggregatable"](resultObj: resultObj)
    $resultsHtml.appendTo @container

  appendAggregatableResults: (resultObj)->
    colors = ["#E6781E",
              "#1693A7",
              "#C8CF02",
              "#F8FCC1",
              "#CC0C39",
              "#FFFFFF",
              "#000000"]
    colors = @col

    # convert results to chart.js data format
    # fetch all values, and assign a color
    chartData = $.map _.values(resultObj.results), (value, index)->
      value: value, color: colors[index]
    legendData = $.map _.keys(resultObj.results), (key, index)->
      key: key, color: colors[index]

    $resultsHtml = $ JST["templates/aggregatable"]
      resultObj:  resultObj
      legendData: legendData
    $resultsHtml.appendTo @container

    ctx = $resultsHtml.find("canvas").get(0).getContext("2d")
    new Chart(ctx).Pie(chartData, {segmentStrokeColor : "#D5D5D5"})

  render: ->
    jsonUrl = "/surveys/question_groups/#{@questionGroupId}/results"
    $.ajax jsonUrl, dataType: "json", success: @onJSONResults
